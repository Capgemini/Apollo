/* Security group for the bastion server */
resource "azure_security_group" "bastion" {
  name = "bastion-apollo-mesos"
  location = "${var.region}"
}

/* Security group for web traffic */
resource "azure_security_group" "web" {
  name = "web-apollo-mesos"
  location = "${var.region}"
}

resource "azure_security_group_rule" "public_ssh_access" {
  name = "ssh-access-rule"
  security_group_names = ["${azure_security_group.bastion.name}"]
  type = "Inbound"
  action = "Allow"
  priority = 200
  source_address_prefix = "*"
  source_port_range = "*"
  destination_address_prefix = "${var.public_subnet_cidr_block}"
  destination_port_range = "22"
  protocol = "TCP"
}

resource "azure_security_group_rule" "open_vpn" {
  name = "open-vpn-rule"
  security_group_names = ["${azure_security_group.bastion.name}"]
  type = "Inbound"
  action = "Allow"
  priority = 201
  source_address_prefix = "*"
  source_port_range = "*"
  destination_address_prefix = "${var.public_subnet_cidr_block}"
  destination_port_range = "1194"
  protocol = "UDP"
}

resource "azure_security_group_rule" "https" {
  name = "https-rule"
  security_group_names = ["${azure_security_group.bastion.name}"]
  type = "Outbound"
  action = "Allow"
  priority = 202
  source_address_prefix = "*"
  source_port_range = "*"
  destination_address_prefix = "${var.public_subnet_cidr_block}"
  destination_port_range = "443"
  protocol = "TCP"
}

resource "azure_security_group_rule" "http" {
  name = "http-rule"
  security_group_names = ["${azure_security_group.bastion.name}", "${azure_security_group.web.name}"]
  type = "Outbound"
  action = "Allow"
  priority = 203
  source_address_prefix = "*"
  source_port_range = "*"
  destination_address_prefix = "*"
  destination_port_range = "80"
  protocol = "TCP"
}
