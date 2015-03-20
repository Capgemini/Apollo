variable "access_key" {}
variable "secret_key" {}
variable "key_name" {}
variable "key_file" {}
variable "zone_id" {}
variable "atlas_token" {}

variable "region" {
  description = "The AWS region to create resources in."
  default = "eu-west-1"
}

variable "subnet_availability_zone" {
  description = "Availability zone for mesos-ceph subnet."
  default = "eu-west-1b"
}

variable "vpc_cidr_block" {
  description = "Cidr block for the VPC."
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "CIDR for public subnet"
  default     = "10.0.0.0/24"
}

variable "private_subnet_cidr_block" {
  description = "Cidr block for mesos subnet."
  default = "10.0.1.0/24"
}

variable "slaves" {
  description = "The number of slaves."
  default = "1"
}

variable "masters" {
  description = "The number of masters."
  default = "1"
}

variable "master_ips" {
  default = {
    master-0 = "10.0.1.11"
    master-1 = "10.0.1.12"
    master-2 = "10.0.1.13"
  }
}

variable "slave_block_device" {
  description = "Block device for OSD."
  default = {
    volume_size = 30
  }
}

variable "instance_type" {
  default = {
    master = "m1.medium"
    slave  = "m1.medium"
  }
}

variable "atlas_artifact" {
  default = {
    master = "capgemini/mesos-0.21.0_ubuntu-14.04_amd64"
    slave  = "capgemini/mesos-0.21.0_ubuntu-14.04_amd64"
  }
}

/* Base Ubuntu 14.04 amis by region */
variable "amis" {
  description = "Base AMI to launch the instances with"
  default = {
    eu-west-1 = "ami-234ecc54"
  }
}

