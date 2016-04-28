#Create Network Security Group
resource "azurerm_network_security_group" "network_security_group" {
    name = "AzureRM_NetworkSecurityGroup"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"

    security_rule {
        name = "AzureRM_SecurityRuleSSH"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
	
	security_rule {
        name = "AzureRM_SecurityRuleOpenVPN"
        priority = 101
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "1194"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
	
	security_rule {
        name = "AzureRM_SecurityRuleOpenHTTPS"
        priority = 102
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "443"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
	
	security_rule {
        name = "AzureRM_SecurityRuleOpenHTTP"
        priority = 103
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "80"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
}

