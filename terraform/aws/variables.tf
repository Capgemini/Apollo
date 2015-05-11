variable "access_key" {
  description = "The aws access key."
  default = ""
}

variable "secret_key" {
  description = "The aws secret key."
  default = ""
}

variable "key_name" {
  description = "The aws ssh key name."
  default = "Apollo"
}

variable "key_file" {
  description = "The ssh public key for using with the cloud provider."
  default = ""
}

variable "atlas_infrastructure" {
  description = "The Atlas infrastructure project to join."
  default = "capgemini/infrastructure"
}

variable "region" {
  description = "The AWS region to create resources in."
  default = "eu-west-1"
}

variable "subnet_availability_zone" {
  description = "Availability zone for Apollo subnet."
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
  description = "Cidr block for private Mesos subnet."
  default = "10.0.1.0/24"
}

variable "slaves" {
  description = "The number of slaves."
  default = "1"
}

variable "masters" {
  description = "The number of masters."
  default = "3"
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
    master = "capgemini/apollo-mesos-ubuntu-14.04-amd64"
    slave  = "capgemini/apollo-mesos-ubuntu-14.04-amd64"
  }
}

/* Base Ubuntu 14.04 amis by region */
variable "amis" {
  description = "Base AMI to launch the instances with"
  default = {
    eu-west-1 = "ami-234ecc54"
  }
}

