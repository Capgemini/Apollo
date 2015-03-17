variable "access_key" {}
variable "secret_key" {}
variable "key_name" {}
variable "key_file" {}
variable "zone_id" {}
variable "mesos_dns" {}

variable "region" {
  description = "The AWS region to create resources in."
  default = "eu-west-1"
}

variable "slaves" {
  description = "The number of slaves."
  default = "1"
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
