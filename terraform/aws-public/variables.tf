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
    ap-northeast-1 = "ami-3f6a4d51"
    ap-southeast-1 = "ami-1e3cfb7d"
    ap-southeast-2 = "ami-ca326ca9"
    eu-central-1   = "ami-de392ab2"
    eu-west-1      = "ami-4972ac3a"
    sa-east-1      = "ami-7076cd1c"
    us-east-1      = "ami-48ef9222"
    us-west-1      = "ami-54610e34"
    us-west-2      = "ami-cb3b2caa"
  }
}
