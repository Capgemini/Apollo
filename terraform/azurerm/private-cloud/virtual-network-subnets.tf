#Create public subnets
resource "azurerm_subnet" "public" {
	name = "AzureRM_Public_Subnet-${count.index}"
	count = "${length(compact(split(",", var.public_subnet_cidr_block)))}"
	resource_group_name = "${azurerm_resource_group.resource_group.name}"
	virtual_network_name = "${azurerm_virtual_network.virtual_network.name}"
	address_prefix = "${element(split(",", var.public_subnet_cidr_block), count.index)}"
	route_table_id = "${azurerm_route_table.public.id}"
}

resource "azurerm_route_table" "public" {
    name = "AzureRM_Public_Route_Table"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"

    route {
        name = "AzureRM_Public_Route"
        address_prefix = "0.0.0.0/0"
        next_hop_type = "Internet"
    }

    tags {
        environment = "default-public"
    }
}

#Create private subnets
resource "azurerm_subnet" "private" {
	name = "AzureRM_Private_Subnet-${count.index}"
	count = "${length(compact(split(",", var.private_subnet_cidr_block)))}"
	resource_group_name = "${azurerm_resource_group.resource_group.name}"
	virtual_network_name = "${azurerm_virtual_network.virtual_network.name}"
	address_prefix = "${element(split(",", var.private_subnet_cidr_block), count.index)}"
	route_table_id = "${azurerm_route_table.private.id}"
}

resource "azurerm_route_table" "private" {
    name = "AzureRM_Private_Route_Table"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"

    route {
        name = "AzureRM_Private_Route"
        address_prefix = "0.0.0.0/0"
        next_hop_type = "VirtualAppliance"
		next_hop_in_ip_address = "${azurerm_network_interface.bastion_network_interface.private_ip_address}"
    }

    tags {
        environment = "default-private"
    }
}

# Public subnets output
output "subnet_ids" {
	value = "${join(",", azurerm_subnet.public.*.id)}"
}

output "subnet_ip_configurations" {
	value = "${join(",", azurerm_subnet.public.ip_configurations)}"
}

output "public_route_table_id" {
	value = "${azurerm_route_table.public.id}"
}

output "public_route_table_subnets" {
	value = "${join(",", azurerm_route_table.public.subnets)}"
}

# Private subnets output
output "subnet_ids" {
	value = "${join(",", azurerm_subnet.private.*.id)}"
}

output "subnet_ip_configurations" {
	value = "${join(",", azurerm_subnet.private.ip_configurations)}"
}

output "private_route_table_id" {
	value = "${azurerm_route_table.private.id}"
}

output "private_route_table_subnets" {
	value = "${join(",", azurerm_route_table.private.subnets)}"
}

