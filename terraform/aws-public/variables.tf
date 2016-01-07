variable "access_key" {}
variable "secret_key" {}
variable "public_key_file" { default = "~/.ssh/id_rsa_aws.pub" }
variable "region" { default = "eu-west-1" }
variable "availability_zones" { default = "eu-west-1a,eu-west-1b,eu-west-1c" }
variable "coreos_channel" { default = "stable" }
variable "etcd_discovery_url_file" { default = "etcd_discovery_url.txt" }
variable "masters" { default = "3" }
variable "master_instance_type" { default = "m3.medium" }
variable "slaves" { default = "1" }
variable "slave_instance_type" { default = "m3.medium" }
variable "vpc_cidr_block" { default = "10.0.0.0/16" }
