variable "username" {
  description = "The username used to authenticate to openstack provider"
  default = ""
}

variable "password" {
  description = "The password used to authenticate to openstack provider"
  default = ""
}

variable "tenant_id" {
  description = "The tenant id"
  default = ""
}

variable "endpoint_type" {
  description = "Whether to use public or private endpoint"
  default = "public"
}

variable "auth_url" {
  description = "The auth url used to authenticate"
  default = "https://identity.api.rackspacecloud.com/v2.0"
}

variable "api_key" {
  description = "The ssh public key for using with the cloud provider."
  default = ""
}

variable "atlas_infrastructure" {
  description = "The Atlas infrastructure project to join."
  default = "capgemini/infrastructure"
}

variable "region" {
  description = "The OpenStack region to create resources in."
  default = "LON"
}

variable "key_name" {
  description = "The openstack ssh key name."
  default = "deployer"
}

variable "key_file" {
  description = "The ssh public key for using with the cloud provider."
  default = ""
}

variable "vpc_cidr_block" {
  description = "Cidr block for the VPC."
  default = "10.0.0.0/16"
}

variable "network_id" {
  description = "id of the network router interface"
  default = "f67f0d72-0ddf-11e4-9d95-e1f29f417e2f"
}

variable "public_subnet_cidr_block" {
  description = "CIDR for public subnet"
  default     = "192.168.199.0/24"
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
    master = "general1-1"
    slave  = "general1-1"
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
    master = "1"
    slave  = "1"
  }
}
