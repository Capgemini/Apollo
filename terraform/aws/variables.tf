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

variable "private_key_file" {
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

variable "public_subnet_availability_zone" {
  description = "Public availability zone."
  default = ""
}

variable "availability_zones" {
  description = "AWS availability zones list separated by ','"
  default = ""
}

variable "vpc_cidr_block" {
  description = "Cidr block for the VPC."
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "CIDR for public subnet"
  default     = "10.0.0.0/24"
}

variable "slaves" {
  description = "The number of slaves."
  default = "1"
}

variable "masters" {
  description = "The number of masters."
  default = "3"
}

variable "block_device" {
  description = "Block device for OSD."
  default = {
    volume_size = 50
  }
}

variable "slave_root_device" {
  description = "Root device for OS"
  default = {
    volume_size = 30
  }
}

variable "instance_type" {
  default = {
    master = "m3.medium"
    slave  = "m3.medium"
  }
}

variable "bastion_instance_type" {
  default = "t2.micro"
}

variable "atlas_artifact" {
  default = {
    master = "capgemini/apollo-ubuntu-14.04-amd64"
    slave  = "capgemini/apollo-ubuntu-14.04-amd64"
  }
}

variable "atlas_artifact_version" {
  default = {
    master = "13"
    slave  = "13"
  }
}
