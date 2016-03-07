# Variables

variable "region"                  { default = "LON" }
variable "instance_type"           { default = "general1-4" }
variable "image_id"                { default = "40155f16-21d4-4ac1-ad65-c409d94b8c7c" }
variable "key_pair"                { default = "apollo" }
variable "public_network_id"       { default = "00000000-0000-0000-0000-000000000000" }
variable "public_network_name"     { default = "PublicNet" }
variable "private_network_id"      { default = "11111111-1111-1111-1111-111111111111" }
variable "private_network_name"    { default = "ServiceNet" }
variable "security_groups"         { default = "default" }
variable "etcd_discovery_url_file" {}
variable "masters"                 { default = "3" }
variable "slaves"                  { default = "1" }
variable "etcd_discovery_ready"    { default = "" }
variable "volume_size"             { default = 75 } # Minimum allowed size by Rackspace
variable "volume_device"           { default = "/dev/xvdb" }
variable "volume_type"             { default = "SSD" } # Can be either SATA or SSD
 
# Resources

resource "template_file" "slave_cloud_init" {
  template               = "${path.module}/slave-cloud-config.yml.tpl"
  vars {
    etcd_discovery_url   = "${file(var.etcd_discovery_url_file)}"
    etcd_discovery_ready = "${var.etcd_discovery_ready}"
    size                 = "${var.masters + var.slaves}"
  }
}

resource "openstack_blockstorage_volume_v1" "mesos-slave-blockstorage" {
  region         = "${var.region}"
  name           = "mesos-slave-blockstorage-${count.index}"
  description    = "mesos-slave-blockstorage-${count.index}"
  size           = "${var.volume_size}"
  count          = "${var.slaves}"
  volume_type    = "${var.volume_type}"
  metadata {
    description  = "mesos-slave-blockstorage"
  }
}

resource "openstack_compute_instance_v2" "mesos-slave" {
  region            = "${var.region}"
  name              = "apollo-mesos-slave-${count.index}"
  flavor_id         = "${var.instance_type}"
  image_id          = "${var.image_id}"
  count             = "${var.slaves}"
  key_pair          = "${var.key_pair}"
  network           =
    {
      uuid           = "${var.public_network_id}"
      name           = "${var.public_network_name}"
    }
  network           =
    {
      uuid          = "${var.private_network_id}"
      name          = "${var.private_network_name}"
    }
  volume {
    volume_id       = "${element(openstack_blockstorage_volume_v1.mesos-slave-blockstorage.*.id, count.index)}"
    device          = "${var.volume_device}"
  }
  # security_groups   = ["${var.security_groups}"] # Comment this in for Openstack providers that support security groups via terraform.
  config_drive      = "true"
  user_data         = "${template_file.slave_cloud_init.rendered}"
  # Metadata needed by the terraform.py script in order to populate our Ansible inventory properly.
  metadata {
    role            = "mesos_slaves"
    dc              = "${var.region}"
  }
}

# Outputs

output "slave_ips" {
  value = "${join(",", openstack_compute_instance_v2.mesos-slave.*.access_ip_v4)}"
}
