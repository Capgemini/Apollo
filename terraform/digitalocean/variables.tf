variable "do_token" {}
variable "key_file" {}

variable "region" {
  description = "The Digital Ocean region to create resources in."
  default = "lon1"
}

variable "masters" {
  description = "The number of masters."
  default = "3"
}

variable "slaves" {
  description = "The number of slaves."
  default = "1"
}

variable "instance_size" {
  default = {
    master = "512mb"
    slave  = "512mb"
  }
}

variable "atlas_artifact" {
  default = {
    master = "capgemini/apollo-mesos-ubuntu-14.04-amd64"
    slave  = "capgemini/apollo-mesos-ubuntu-14.04-amd64"
  }
}
