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
    lb     = "512mb"
  }
}

variable "image" {
  description = "Base Image to launch the droplets with"
  default = {
    master = "11147507"
    slave  = "11147507"
    lb     = "11147507"
  }
}

