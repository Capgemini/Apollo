variable "do_token" {}
variable "public_key_file" { default = "~/.ssh/digitalocean.pub" }
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

# ssh keypair for instances
module "do-keypair" {
  source = "./keypair"

  public_key_file = "${var.public_key_file}"
}

# Generate an etcd URL for the cluster
resource "template_file" "etcd_discovery_url" {
  template = "/dev/null"
  provisioner "local-exec" {
    command = "curl https://discovery.etcd.io/new?size=${var.masters} > ${var.etcd_discovery_url_file}"
  }
  # This will regenerate the discovery URL if the cluster size changes
  vars {
    size = "${var.masters}"
  }
}

resource "template_file" "master_cloud_init" {
  template   = "master-cloud-config.yml.tpl"
  depends_on = ["template_file.etcd_discovery_url"]
  vars {
    etcd_discovery_url = "${file(var.etcd_discovery_url_file)}"
    size               = "${var.masters}"
    region             = "${var.region}"
  }
}

resource "template_file" "slave_cloud_init" {
  template   = "slave-cloud-config.yml.tpl"
  depends_on = ["template_file.etcd_discovery_url"]
  vars {
    etcd_discovery_url = "${file(var.etcd_discovery_url_file)}"
    size               = "${var.masters}"
    region             = "${var.region}"
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
    "${module.do-keypair.keypair_id}"
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
    "${module.do-keypair.keypair_id}"
  ]
}

# Outputs
output "master_ips" {
  value = "${join(",", digitalocean_droplet.mesos-master.*.ipv4_address)}"
}
output "slave_ips" {
  value = "${join(",", digitalocean_droplet.mesos-slave.*.ipv4_address)}"
}
