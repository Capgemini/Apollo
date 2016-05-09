#Create Public IP Address for master servers
resource "azurerm_public_ip" "master_publicip" {
    name = "MasterPublicIp-${count.index}" 
	count = "${var.master_count}" 
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    public_ip_address_allocation = "static"
}