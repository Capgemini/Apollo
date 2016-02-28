resource "azure_virtual_network" "virtual-network" {
  name = "virtual-network"
  address_space = ["${var.vn_cidr_block}"]
  location = "${var.region}"

  subnet {
    name = "private"
    address_prefix = "${var.private_subnet_cidr_block}"
  }

  subnet {
    name = "public"
    address_prefix = "${var.public_subnet_cidr_block}"
  }
}
