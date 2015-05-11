
variable "key_file" {
  description = "The ssh public key for using with the cloud provider."
  default = ""
}

variable "do_token" {
  description = "The Digital Ocean token."
  default = ""
}

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

variable "atlas_artifact_version" {
  default = {
    master = "1"
    slave  = "1"
  }
}
