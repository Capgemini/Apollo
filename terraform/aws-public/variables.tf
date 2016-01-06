variable "access_key" {}
variable "secret_key" {}
variable "key_name" { default = "deployer"}
variable "key_file" {}
variable "region" { default = "eu-west-1" }
variable "coreos_channel" { default = "stable" }
variable "masters" { default = "3" }
variable "elb_name" { default = "apollo-elb" }
variable "slaves" { default = "1" }
variable "vpc_cidr_block" { default = "10.0.0.0/16" }
variable "etcd_discovery_url_file" { default = "etcd_discovery_url.txt" }

variable "availability_zones" {
  description = "AWS availability zones list separated by ','"
  default     = ""
}

variable "slave_block_device" {
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
