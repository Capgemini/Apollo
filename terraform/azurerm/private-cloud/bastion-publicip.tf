#Create Public IP Address for bastion server
resource "azurerm_public_ip" "bastion_publicip" {
	name = "BastionPublicIp"
	location = "${var.region}"
	resource_group_name = "${azurerm_resource_group.resource_group.name}"
	public_ip_address_allocation = "static"
}

#Output
output "bastion_publicip_id" {
	value = "${azurerm_public_ip.bastion_publicip.id}"
}

output "bastion_publicip_ipaddress" {
	value = "${azurerm_public_ip.bastion_publicip.ip_address}"
}

output "bastion_publicip_fqdn" {
	value = "${azurerm_public_ip.bastion_publicip.fqdn}"
}