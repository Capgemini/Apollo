# Create a virtual network
resource "azurerm_virtual_network" "virtual_network" {
	name = "AzureRM-Virtual-Network"
	resource_group_name = "${azurerm_resource_group.resource_group.name}"
	address_space = ["${var.vpc_cidr_block}"]
	location = "${var.region}"
}

#Output
output "network_confirguration_id" {
	value = "${azurerm_virtual_network.virtual_network.id}"
}