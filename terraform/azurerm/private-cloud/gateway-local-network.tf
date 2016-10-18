#Create Public IP Address for local network gateway
resource "azurerm_local_network_gateway" "gateway" {
	name = "AzureRM_LocalNetworkGateway"
	resource_group_name = "${azurerm_resource_group.resource_group.name}"
	location = "${var.region}"
	gateway_address = "${azurerm_public_ip.bastion_publicip.ip_address}"
	address_space = ["${var.vpc_cidr_block}"]
}

#Output
output "gateway_local_network_id" {
	value = "${azurerm_local_network_gateway.gateway.id}"
}
