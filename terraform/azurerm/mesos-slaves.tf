/*

# Create a network interface for slave server
resource "azurerm_network_interface" "slave_network_interface" {
    name = "Slave_NetworkInterface-${count.index}" 
	count = "${var.slave_count}"
	location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    network_security_group_id = "${azurerm_network_security_group.network_security_group.id}"

    ip_configuration {
        name = "slaveipconfiguration-${count.index}"
        subnet_id = "${azurerm_subnet.subnet.id}"
        private_ip_address_allocation = "dynamic"
		public_ip_address_id = "${element(azurerm_public_ip.slave_publicip.*.id, count.index)}"
    }
}

# Slave server
resource "azurerm_virtual_machine" "mesos_slave" {
    name = "apollo-mesos-slave-${count.index}"
	count = "${var.slave_count}"
    location = "${var.region}"
	depends_on = ["azurerm_virtual_machine.bastion", "azurerm_virtual_machine.mesos_master"]
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    network_interface_ids = ["${element(azurerm_network_interface.slave_network_interface.*.id, count.index)}"] 
    vm_size = "${var.instance_type.slave}"

    storage_image_reference {
    	publisher = "${var.atlas_artifact_slave.publisher}"
		offer = "${var.atlas_artifact_slave.offer}"
		sku = "${var.atlas_artifact_slave.sku}"
		version = "${var.atlas_artifact_slave.version}"
    }

    storage_os_disk {
        name = "slavedisk${count.index}"
        vhd_uri = "${azurerm_storage_account.storage_account.primary_blob_endpoint}${azurerm_storage_container.storage_container.name}/slavedisk-${count.index}.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
	computer_name = "Mesos-Slave-${count.index}"
    	admin_username = "${var.bastion_server_username}"
    	admin_password = "${var.bastion_server_password}"
    }

    os_profile_linux_config {
    disable_password_authentication = false
    }
}

*/