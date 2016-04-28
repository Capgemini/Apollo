#Create Public IP Address for bastian server
resource "azurerm_public_ip" "bastian_publicip" {
    name = "BastianPublicIp"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    public_ip_address_allocation = "static"
}