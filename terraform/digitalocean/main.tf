variable "do_token" {}
variable "organization" { default = "apollo" }
variable "region" { default = "lon1" }
variable "masters" { default = "3" }
variable "slaves" { default = "1" }
variable "master_instance_type" { default = "512mb" }
variable "slave_instance_type" { default = "512mb" }
variable "etcd_discovery_url_file" { default = "etcd_discovery_url.txt" }
variable "coreos_image" { default = "coreos-stable" }

# Provider
provider "digitalocean" {
  token = "${var.do_token}"
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

resource "digitalocean_ssh_key" "default" {
  name       = "${var.organization}"
  public_key = "${tls_private_key.ssh.public_key_openssh}"
}

# Export ssh key so we can login with core@instance -i id_rsa
resource "null_resource" "keys" {
  depends_on = ["tls_private_key.ssh"]

  provisioner "local-exec" {
    command = "echo '${tls_private_key.ssh.private_key_pem}' > ${path.module}/id_rsa && chmod 600 ${path.module}/id_rsa"
  }
}

resource "tls_private_key" "ca" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm = "RSA"
  private_key_pem = "${tls_private_key.ca.private_key_pem}"

  subject {
    common_name = "*"
    organization = "${var.organization}"
  }

  allowed_uses = [
    "key_encipherment",
    "cert_signing",
    "server_auth",
    "client_auth"
  ]

  validity_period_hours = 43800

  early_renewal_hours = 720

  is_ca_certificate = true
}

resource "tls_private_key" "etcd" {
  algorithm = "RSA"
}

resource "tls_cert_request" "etcd" {
  key_algorithm = "RSA"

  private_key_pem = "${tls_private_key.etcd.private_key_pem}"

  subject {
    common_name = "*"
    organization = "etcd"
  }
}

resource "tls_locally_signed_cert" "etcd" {
  cert_request_pem = "${tls_cert_request.etcd.cert_request_pem}"

  ca_key_algorithm = "RSA"
  ca_private_key_pem = "${tls_private_key.ca.private_key_pem}"
  ca_cert_pem = "${tls_self_signed_cert.ca.cert_pem}"

  validity_period_hours = 43800

  early_renewal_hours = 720

  allowed_uses = [
    "key_encipherment",
    "server_auth",
    "client_auth"
  ]
}

# Generate an etcd URL for the cluster
resource "template_file" "etcd_discovery_url" {
  template = "/dev/null"
  provisioner "local-exec" {
    command = "curl https://discovery.etcd.io/new?size=${var.masters + var.slaves} > ${var.etcd_discovery_url_file}"
  }
  # This will regenerate the discovery URL if the cluster size changes
  vars {
    size = "${var.masters + var.slaves}"
  }
}

resource "template_file" "master_cloud_init" {
  template   = "master-cloud-config.yml.tpl"
  depends_on = ["template_file.etcd_discovery_url"]
  vars {
    etcd_discovery_url = "${file(var.etcd_discovery_url_file)}"
    size               = "${var.masters + var.slaves}"
    etcd_ca            = "${replace(tls_self_signed_cert.ca.cert_pem, \"\n\", \"\\n\")}"
    etcd_cert          = "${replace(tls_locally_signed_cert.etcd.cert_pem, \"\n\", \"\\n\")}"
    etcd_key           = "${replace(tls_private_key.etcd.private_key_pem, \"\n\", \"\\n\")}"
  }
}

resource "template_file" "slave_cloud_init" {
  template   = "slave-cloud-config.yml.tpl"
  depends_on = ["template_file.etcd_discovery_url"]
  vars {
    etcd_discovery_url = "${file(var.etcd_discovery_url_file)}"
    size               = "${var.masters + var.slaves}"
    etcd_ca            = "${replace(tls_self_signed_cert.ca.cert_pem, \"\n\", \"\\n\")}"
    etcd_cert          = "${replace(tls_locally_signed_cert.etcd.cert_pem, \"\n\", \"\\n\")}"
    etcd_key           = "${replace(tls_private_key.etcd.private_key_pem, \"\n\", \"\\n\")}"
  }
}

# Masters
resource "digitalocean_droplet" "mesos-master" {
  image              = "${var.coreos_image}"
  region             = "${var.region}"
  count              = "${var.masters}"
  name               = "apollo-mesos-master-${count.index}"
  size               = "${var.master_instance_type}"
  private_networking = true
  user_data          = "${template_file.master_cloud_init.rendered}"
  ssh_keys = [
    "${digitalocean_ssh_key.default.id}"
  ]
}

# Slaves
resource "digitalocean_droplet" "mesos-slave" {
  image              = "${var.coreos_image}"
  region             = "${var.region}"
  count              = "${var.slaves}"
  name               = "apollo-mesos-slave-${count.index}"
  size               = "${var.slave_instance_type}"
  private_networking = true
  user_data          = "${template_file.slave_cloud_init.rendered}"
  ssh_keys = [
    "${digitalocean_ssh_key.default.id}"
  ]
}

# Outputs
output "master_ips" {
  value = "${join(",", digitalocean_droplet.mesos-master.*.ipv4_address)}"
}
output "slave_ips" {
  value = "${join(",", digitalocean_droplet.mesos-slave.*.ipv4_address)}"
}
