variable "access_key" {}
variable "secret_key" {}
variable "key_name" { default = "deployer"}
variable "key_file" {}
variable "region" { default = "eu-west-1" }
variable "availability_zones" { default = "" } # zones list separated by ,
variable "coreos_channel" { default = "stable" }
variable "etcd_discovery_url_file" { default = "etcd_discovery_url.txt" }
variable "masters" { default = "3" }
variable "master_instance_type" { default = "m3.medium" }
variable "slaves" { default = "1" }
variable "slave_instance_type" { default = "m3.medium" }
variable "elb_name" { default = "apollo-elb" }
variable "vpc_cidr_block" { default = "10.0.0.0/16" }
