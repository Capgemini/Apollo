#Create Network Security Group
resource "azurerm_network_security_group" "network_security_group" {
	name = "AzureRM_BastionNetworkSecurityGroup"
	location = "${var.region}"
	resource_group_name = "${azurerm_resource_group.resource_group.name}"

	security_rule {
		name = "AzureRM_SecurityRuleInbound"
		priority = 100
		direction = "Inbound"
		access = "Allow"
		protocol = "*"
		source_port_range = "*"
		destination_port_range = "*"
		source_address_prefix = "*"
		destination_address_prefix = "*"
	}

	security_rule {
		name = "AzureRM_SecurityRuleOutbound"
		priority = 101
		direction = "Outbound"
		access = "Allow"
		protocol = "*"
		source_port_range = "*"
		destination_port_range = "*"
		source_address_prefix = "*"
		destination_address_prefix = "*"
	}
	
	tags { 
		Name = "default-apollo-sg" 
	} 
}

#Output
output "network_security_group_id" {
	value = "${azurerm_network_security_group.network_security_group.id}"
}
