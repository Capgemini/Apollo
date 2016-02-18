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

variable "elasticsearch_instances" {
  description = "The number of ES hosts to provision."
  default = "1"
}

variable "slave_block_device" {
  description = "Block device for OSD."
  default = {
    volume_size = 80
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

variable "docker_version" {
  description = "Docker version"
  default = "1.9.0-0~trusty"
}

/* Remember to update the list every time when you build a new artifact on atlas */
variable "amis" {
  default = {
    ap-northeast-1 = "ami-113d1a7f"
    ap-southeast-1 = "ami-7c53941f"
    ap-southeast-2 = "ami-4a5e0029"
    eu-central-1   = "ami-372b385b"
    eu-west-1      = "ami-a1b26bd2"
    sa-east-1      = "ami-be58e3d2"
    us-east-1      = "ami-6e562a04"
    us-west-1      = "ami-b25a35d2"
    us-west-2      = "ami-9ef6e1ff"
  }
}

variable "cloudwatch_vpc_flow_log_group" {
  description = "Name of the Cloudwatch log group for VPC Flow Logs"
  default = ""
}

