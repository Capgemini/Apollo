/*

#Create Public IP Address for slave servers
resource "azurerm_public_ip" "slave_publicip" {
    name = "SlavePublicIp-${count.index}" 
	count = "${var.slave_count}" 
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    public_ip_address_allocation = "static"
}

*/
