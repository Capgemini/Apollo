# Variables
variable "key_name"        { default = "apollo" }
variable "public_key_file" { default = "~/.ssh/id_rsa_rs.pub" }

# SSH keypair resource
resource "openstack_compute_keypair_v2" "default" {
  name       = "${var.key_name}"
  public_key = "${file(var.public_key_file)}"
}

# Outputs
output "keypair_name" {
  value = "${openstack_compute_keypair_v2.default.name}"
}
