#Create Subnet
resource "azurerm_subnet" "subnet" {
	name = "AzureRM_Subnet"
	resource_group_name = "${azurerm_resource_group.resource_group.name}"
	virtual_network_name = "${azurerm_virtual_network.virtual_network.name}"
	address_prefix = "${var.subnet_cidr_block}"
}

#Output
output "subnet_id" {
	value = "${azurerm_subnet.subnet.id}"
}

output "subnet_ip_configurations" {
	value = "${azurerm_subnet.subnet.ip_configurations}"
}