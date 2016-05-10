# Create a network interface for agent server
resource "azurerm_network_interface" "agent_network_interface" {
	name = "Agent_NetworkInterface-${count.index}" 
	count = "${var.agent_count}"
	location = "${var.region}"
	resource_group_name = "${azurerm_resource_group.resource_group.name}"
	network_security_group_id = "${azurerm_network_security_group.network_security_group.id}"

	ip_configuration {
		name = "agentipconfiguration-${count.index}"
		subnet_id = "${azurerm_subnet.subnet.id}"
		private_ip_address_allocation = "dynamic"
		public_ip_address_id = "${element(azurerm_public_ip.agent_publicip.*.id, count.index)}"
	}
}

# Agent server
resource "azurerm_virtual_machine" "mesos_agent" {
	name = "apollo-mesos-agent-${count.index}"
	count = "${var.agent_count}"
	location = "${var.region}"
	depends_on = ["azurerm_virtual_machine.bastion", "azurerm_virtual_machine.mesos_master"]
	resource_group_name = "${azurerm_resource_group.resource_group.name}"
	network_interface_ids = ["${element(azurerm_network_interface.agent_network_interface.*.id, count.index)}"] 
	vm_size = "${var.instance_type.agent}"

    storage_image_reference {
		publisher = "${var.atlas_artifact_agent.publisher}"
		offer = "${var.atlas_artifact_agent.offer}"
		sku = "${var.atlas_artifact_agent.sku}"
		version = "${var.atlas_artifact_agent.version}"
    }

    storage_os_disk {
        name = "agentdisk${count.index}"
        vhd_uri = "${azurerm_storage_account.storage_account.primary_blob_endpoint}${azurerm_storage_container.storage_container.name}/agentdisk-${count.index}.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
		computer_name = "Mesos-Agent-${count.index}"
    	admin_username = "${var.agent_server_username}"
    	admin_password = "${var.agent_server_password}"
    }

    os_profile_linux_config {
		disable_password_authentication = false
    }
}