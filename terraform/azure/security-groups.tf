/* Default security group */
resource "azure_security_group" "default" {
  name     = "default-apollo-mesos"
  location = "${var.region}"
}

resource "azure_security_group_rule" "all-inbound" {
  name                       = "all-inbound-access-rule"
  security_group_name        = "${azure_security_group.default.name}"
  type                       = "Inbound"
  action                     = "Allow"
  priority                   = 100
  source_address_prefix      = "*"
  source_port_range          = "*"
  destination_address_prefix = "*"
  destination_port_range     = "*"
  protocol                   = "TCP"
}

resource "azure_security_group_rule" "all-outbound" {
  name                       = "all-outbound-access-rule"
  security_group_name        = "${azure_security_group.default.name}"
  type                       = "Outbound"
  action                     = "Allow"
  priority                   = 100
  source_address_prefix      = "*"
  source_port_range          = "*"
  destination_address_prefix = "*"
  destination_port_range     = "*"
  protocol                   = "TCP"
}
