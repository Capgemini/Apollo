#Create Network Security Group
resource "azurerm_network_security_group" "network_security_group" {
    name = "AzureRM_NetworkSecurityGroup"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"

    security_rule {
        name = "AzureRM_SecurityRuleTcp"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "*"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
}