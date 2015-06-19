variable "azure_settings_file" {
  description = "The Azure settings file."
  default = ""
}

variable "username" {
  description = "The Azure instance username."
  default = ""
}

/* @todo - replace */
variable "password" {
  description = "The Azure instance password."
  default = ""
}

variable "ssh_key_thumbprint" {
  description = "The Azure SSH key thumbprint."
  default = ""
}

variable "region" {
  description = "The Azure region to create resources in."
  default = "North Europe"
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
    master = "Standard_A1"
    slave  = "Standard_A1"
  }
}
