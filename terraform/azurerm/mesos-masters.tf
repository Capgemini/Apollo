/*

# Create a network interface for master server
resource "azurerm_network_interface" "master_network_interface" {
    name = "Master_NetworkInterface-${count.index}" 
	count = "${var.master_count}"
	location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    network_security_group_id = "${azurerm_network_security_group.network_security_group.id}"

    ip_configuration {
        name = "masteripconfiguration-${count.index}"
        subnet_id = "${azurerm_subnet.subnet.id}"
        private_ip_address_allocation = "dynamic"
		public_ip_address_id = "${element(azurerm_public_ip.master_publicip.*.id, count.index)}"
    }
}

# Master server
resource "azurerm_virtual_machine" "mesos_master" {
    name = "apollo-mesos-master-${count.index}"
	count = "${var.master_count}"
    location = "${var.region}"
	depends_on = ["azurerm_virtual_machine.bastion"]
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    network_interface_ids = ["${element(azurerm_network_interface.master_network_interface.*.id, count.index)}"] 
    vm_size = "${var.instance_type.master}"

    storage_image_reference {
    	publisher = "${var.atlas_artifact_master.publisher}"
		offer = "${var.atlas_artifact_master.offer}"
		sku = "${var.atlas_artifact_master.sku}"
		version = "${var.atlas_artifact_master.version}"
    }

    storage_os_disk {
        name = "masterdisk${count.index}"
        vhd_uri = "${azurerm_storage_account.storage_account.primary_blob_endpoint}${azurerm_storage_container.storage_container.name}/masterdisk-${count.index}.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
	computer_name = "Mesos-Master-${count.index}"
    	admin_username = "${var.bastion_server_username}"
    	admin_password = "${var.bastion_server_password}"
    }

    os_profile_linux_config {
    disable_password_authentication = false
    }
}

*/