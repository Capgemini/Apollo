#Create Public IP Address for agent servers
resource "azurerm_public_ip" "agent_publicip" {
    name = "AgentPublicIp-${count.index}" 
	count = "${var.agent_count}" 
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    public_ip_address_allocation = "static"
}