variable "name" { default = "apollo" }
variable "public_key_file" { default = "~/.ssh/digitalocean.pub" }

resource "digitalocean_ssh_key" "default" {
  name       = "${var.name}"
  public_key = "${file(var.public_key_file)}"
}

output "keypair_id" {
  value = "${digitalocean_ssh_key.default.id}"
}
