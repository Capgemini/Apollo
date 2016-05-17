#Create public subnets
resource "azurerm_subnet" "public" {
	name = "AzureRM_Public_Subnet-${count.index}"
	count = "${length(compact(split(",", var.public_subnet_cidr_block)))}"
	resource_group_name = "${azurerm_resource_group.resource_group.name}"
	virtual_network_name = "${azurerm_virtual_network.virtual_network.name}"
	address_prefix = "${element(split(",", var.public_subnet_cidr_block), count.index)}"
}

#Create private subnets
resource "azurerm_subnet" "private" {
	name = "AzureRM_Private_Subnet-${count.index}"
	count = "${length(compact(split(",", var.private_subnet_cidr_block)))}"
	resource_group_name = "${azurerm_resource_group.resource_group.name}"
	virtual_network_name = "${azurerm_virtual_network.virtual_network.name}"
	address_prefix = "${element(split(",", var.private_subnet_cidr_block), count.index)}"
}

# Public subnets output
output "subnet_ids" {
	value = "${join(",", azurerm_subnet.public.*.id)}"
}

output "subnet_ip_configurations" {
	value = "${join(",", azurerm_subnet.public.ip_configurations)}"
}

# Private subnets output
output "subnet_ids" {
	value = "${join(",", azurerm_subnet.private.*.id)}"
}

output "subnet_ip_configurations" {
	value = "${join(",", azurerm_subnet.private.ip_configurations)}"
}