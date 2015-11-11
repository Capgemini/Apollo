variable "account_file" {
  description = "The gce account file."
  default     = ""
}
 
variable "project" {
  description = "The gce project."
  default = ""
}

variable "region" {
  description = "The AWS region to create resources in."
  default     = "europe-west1"
}

variable "gce_user" {
  description = "The gce ssh user name."
  default     = "Apollo"
}

variable "atlas_infrastructure" {
  description = "The Atlas infrastructure project to join."
  default     = "capgemini/infrastructure"
}

variable "zone" {
  description = "Availability zone for Apollo."
  default     = "europe-west1-b"
}

variable "slaves" {
  description = "The number of slaves."
  default     = "1"
}

variable "masters" {
  description = "The number of masters."
  default     = "3"
}

variable "instance_type" {
  default = {
    master = "n1-standard-2"
    slave  = "n1-standard-2"
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
