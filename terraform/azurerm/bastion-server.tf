# Create a network interface for bastion server
resource "azurerm_network_interface" "bastion_network_interface" {
    name = "Bastion_NetworkInterface"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    network_security_group_id = "${azurerm_network_security_group.network_security_group.id}"

    ip_configuration {
        name = "bastionipconfiguration"
        subnet_id = "${azurerm_subnet.subnet.id}"
        private_ip_address_allocation = "dynamic"
		public_ip_address_id = "${azurerm_public_ip.bastion_publicip.id}"
    }
}

# NAT/VPN server
resource "azurerm_virtual_machine" "bastion" {
    name = "apollo-bastion"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    network_interface_ids = ["${azurerm_network_interface.bastion_network_interface.id}"]
    vm_size = "${var.instance_type.master}"

    storage_image_reference {
    	publisher = "Canonical"
		offer = "UbuntuServer"
		sku = "14.04.2-LTS"
		version = "latest"
    }

    storage_os_disk {
        name = "bastiondisk"
        vhd_uri = "${azurerm_storage_account.storage_account.primary_blob_endpoint}${azurerm_storage_container.storage_container.name}/bastiondisk.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
	computer_name = "${var.bastion_server_computername}"
    	admin_username = "${var.bastion_server_username}"
    	admin_password = "${var.bastion_server_password}"
    }

    os_profile_linux_config {
    disable_password_authentication = false
    }
}
