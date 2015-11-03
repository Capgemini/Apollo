variable "cluster_name" {
  description = "unique name for cluster"
  default = "berlioz-test"
}

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

variable "ssl_certificate_arn" {
  description = "arn for ssl certificate"
  default = ""
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

variable "public_subnet_cidr_blocks" {
  description = "CIDR for public subnets separated by ','"
  default     = ""
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR for private subnets separated by ','"
  default     = ""
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

variable "elasticsearch_block_device" {
  description = "Block device for elasticsearch."
  default = {
    volume_size = 80
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
    master = "25"
    slave  = "25"
  }
}

/* Remember to update the list every time when you build a new artifact on atlas */
variable "amis" {
  default = {
    ap-northeast-1 = "ami-75dcf81b"
    ap-southeast-1 = "ami-7324e310"
    ap-southeast-2 = "ami-a60c52c5"
    eu-central-1 = "ami-950b18f9"
    eu-west-1 = "ami-f603dd85"
    sa-east-1 = "ami-da962db6"
    us-east-1 = "ami-be106dd4"
    us-west-1 = "ami-7b046b1b"
    us-west-2 = "ami-00657261"
  }
}
