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
  default = "deployer"
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

variable "vpc_cidr_block" {
  description = "Cidr block for the VPC."
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "AWS availability zones list separated by ','"
  default     = ""
}

variable "elb_name" {
  description = "Elb name"
  default     = "apollo-elb"
}

variable "slaves" {
  description = "The number of slaves."
  default = "3"
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
