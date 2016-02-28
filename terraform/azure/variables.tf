variable "azure_settings_file" {
  description = "The Azure settings file."
  default = ""
}

variable "username" {
  description = "The Azure instance username."
  default = ""
}

variable "region" {
  description = "The Azure region to create resources in."
  default = "North Europe"
}

variable "vn_cidr_block" {
  description = "Cidr block for the VN."
  default = "10.0.0.0/16"
}

variable "private_subnet_cidr_block" {
  description = "CIDR for public subnet"
  default     = "10.0.0.0/24"
}

variable "public_subnet_cidr_block" {
  description = "CIDR for public subnet"
  default     = "10.0.1.0/24"
}

variable "slaves" {
  description = "The number of slaves."
  default = "1"
}

variable "masters" {
  description = "The number of masters."
  default = "3"
}

variable "instance_type" {
  default = {
    master = "Medium"
    slave  = "Medium"
  }
}

variable "atlas_artifact" {
  default = {
    master = "apollo-ubuntu-14.04-amd64-1447838899"
    slave  = "apollo-ubuntu-14.04-amd64-1447838899"
  }
}

variable "hosted_service_name" {
  default = {
    master = "apollo-mesos-master"
    slave  = "apollo-mesos-slave"
  }
}

variable "storage_name" {
  description = "Storage name"
  default = "mesosimages"
}

variable "docker_version" {
  description = "Docker version"
  default = "1.9.0-0~trusty"
}
