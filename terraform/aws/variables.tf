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

variable "slave_block_device" {
  description = "Block device for OSD."
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

/* Remember to update the list every time when you build a new artifact on atlas */
variable "amis" {
  default = {
    ap-northeast-1 = "ami-dedc5fde"
    ap-southeast-1 = "ami-8c6e66de"
    ap-southeast-2 = "ami-316f220b"
    eu-central-1 = "ami-7eecea63"
    eu-west-1 = "ami-4c28733b"
    sa-east-1 = "ami-7743c86a"
    us-east-1 = "ami-dbe158b0"
    us-west-1 = "ami-37dc2473"
    us-west-2 = "ami-b1889e81"
  }
}
