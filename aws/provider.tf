provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

# Setup the Consul provisioner to use the demo cluster
provider "consul" {
  address = "example:80"
  datacenter = "ams1"
}