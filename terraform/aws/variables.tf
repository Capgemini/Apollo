variable "access_key" {}
variable "secret_key" {}
variable "key_name" { default = "Apollo" }
variable "ssh_public_key" {}
variable "ssh_private_key" {}
variable "region" { default = "eu-west-1" }
variable "availability_zones" { default = "eu-west-1a,eu-west-1b,eu-west-1c" } # availability zones list separated by ,
variable "vpc_cidr_block" { default = "10.0.0.0/16" }
variable "public_subnet_cidr_block" { default = "10.0.0.0/24" }
variable "public_subnet_availability_zone" { default = "eu-west-1a" }
variable "coreos_channel" { default = "stable" }
variable "etcd_discovery_url_file" { default = "etcd_discovery_url.txt" }
variable "slaves" { default = "1" }
variable "masters" { default = "3" }
variable "master_instance_type" { default = "m3.medium" }
variable "slave_instance_type" { default = "m3.medium" }
variable "bastion_instance_type" { default = "t2.micro" }
variable "docker_version" { default = "1.9.1-0~trusty" }
