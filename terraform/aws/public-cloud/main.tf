variable "access_key" {}
variable "secret_key" {}
variable "public_key_file" { default = "~/.ssh/id_rsa_aws.pub" }
variable "region" { default = "eu-west-1" }
variable "availability_zones" { default = "eu-west-1a,eu-west-1b,eu-west-1c" }
variable "coreos_channel" { default = "stable" }
variable "etcd_discovery_url_file" { default = "etcd_discovery_url.txt" }
variable "masters" { default = "3" }
variable "master_instance_type" { default = "m3.medium" }
variable "slaves" { default = "1" }
variable "slave_instance_type" { default = "m3.medium" }
variable "slave_ebs_volume_size" { default = "30" }
variable "vpc_cidr_block" { default = "10.0.0.0/16" }

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_vpc" "default" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  lifecycle {
    create_before_destroy = true
  }
}

# ssh keypair for instances
module "aws-keypair" {
  source = "../keypair"

  public_key_filename = "${var.public_key_file}"
}

# internet gateway
module "igw" {
  source = "github.com/terraform-community-modules/tf_aws_igw"

  name   = "public"
  vpc_id = "${aws_vpc.default.id}"
}

# public subnets
module "public_subnet" {
  source = "github.com/terraform-community-modules/tf_aws_public_subnet"

  name   = "public"
  cidrs  = "10.0.1.0/24,10.0.2.0/24,10.0.3.0/24"
  azs    = "${var.availability_zones}"
  vpc_id = "${aws_vpc.default.id}"
  igw_id = "${module.igw.igw_id}"
}

# security group to allow all traffic in and out of the instances
module "sg-default" {
  source = "../sg-all-traffic"

  vpc_id = "${aws_vpc.default.id}"
}

module "elb" {
  source = "../elb"

  security_groups = "${module.sg-default.security_group_id}"
  instances       = "${join(\",\", aws_instance.mesos-slave.*.id)}"
  subnets         = "${module.public_subnet.subnet_ids}"
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

# outputs
output "master.1.ip" {
  value = "${aws_instance.mesos-master.0.public_ip}"
}
output "master_ips" {
  value = "${join(",", aws_instance.mesos-master.*.public_ip)}"
}
output "slave_ips" {
  value = "${join(",", aws_instance.mesos-slave.*.public_ip)}"
}
output "elb.hostname" {
  value = "${module.elb.elb_dns_name}"
}
