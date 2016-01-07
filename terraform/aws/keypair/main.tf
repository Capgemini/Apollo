# input variables
variable "short_name" { default = "apollo" }
variable "public_key_filename" { default = "~/.ssh/id_rsa_aws.pub" }

# SSH keypair for the instances
resource "aws_key_pair" "default" {
  key_name   = "${var.short_name}"
  public_key = "${file(var.public_key_filename)}"
}

# output variables
output "keypair_name" {
  value = "${aws_key_pair.default.key_name}"
}
