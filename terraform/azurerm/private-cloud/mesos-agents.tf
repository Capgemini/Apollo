# Create a network interface for agent server
resource "azurerm_network_interface" "agent_network_interface" {
	name = "Agent_NetworkInterface-${count.index}" 
	count = "${var.agent_count}"
	location = "${var.region}"
	resource_group_name = "${azurerm_resource_group.resource_group.name}"
	network_security_group_id = "${azurerm_network_security_group.network_security_group.id}"

	ip_configuration {
		name = "agentipconfiguration-${count.index}"
		subnet_id = "${element(azurerm_subnet.private.*.id, count.index)}"
		private_ip_address_allocation = "dynamic"
	}
}

# User profile template
resource "template_file" "agent_cloud_init" { 
	template = "${file("agent-cloud-config.yml.tpl")}" 
	depends_on = ["template_file.etcd_discovery_url"] 
	vars { 
		etcd_discovery_url = "${file(var.etcd_discovery_url_file)}" 
		size = "${var.master_count}" 
		vpc_cidr_block = "${var.vpc_cidr_block}" 
		region = "${var.region}" 
	} 
}

# Agent server
resource "azurerm_virtual_machine" "mesos_agent" {
	name = "apollo-mesos-agent-${count.index}"
	count = "${var.agent_count}"
	location = "${var.region}"
	availability_set_id = "${azurerm_availability_set.agent.id}"
	depends_on = ["azurerm_virtual_machine.bastion", "azurerm_virtual_machine.mesos_master"]
	resource_group_name = "${azurerm_resource_group.resource_group.name}"
	network_interface_ids = ["${element(azurerm_network_interface.agent_network_interface.*.id, count.index)}"] 
	vm_size = "${var.instance_type.agent}"

	storage_image_reference {
		publisher = "${var.artifact_agent.publisher}"
		offer = "${var.artifact_agent.offer}"
		sku = "${var.artifact_agent.sku}"
		version = "${var.artifact_agent.version}"	
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
		custom_data = "${base64encode(template_file.agent_cloud_init.rendered)}"
    	}

    	os_profile_linux_config {
		disable_password_authentication = true
		
		ssh_keys {
			path = "/home/${var.agent_server_username}/.ssh/authorized_keys"
			key_data = "${file("${var.ssh_public_key_file}")}" # openssh format 
		}
    	}

	tags = { 
		Name = "apollo-mesos-agent-${count.index}" 
		role = "mesos_agents" 
	} 

	connection { 
     		user = "${var.agent_server_username}" 
		host = "${element(azurerm_network_interface.agent_network_interface.*.private_ip_address, count.index)}"
     		private_key = "${file("${var.ssh_private_key_file}")}" # openssh format
     		bastion_host = "${azurerm_public_ip.bastion_publicip.ip_address}"
		bastion_user = "${var.bastion_server_username}"
     		bastion_private_key = "${file("${var.ssh_private_key_file}")}" # openssh format
	}

	# Do some early bootstrapping of the CoreOS machines. This will install 
   	# python and pip so we can use as the ansible_python_interpreter in our playbooks 
   	provisioner "file" {
    
		source      = "../../scripts/coreos" 
     		destination = "/tmp  
	}

	provisioner "remote-exec" { 
		inline = [ 
			"sudo chmod -R +x /tmp/coreos", 
			"/tmp/coreos/bootstrap.sh", 
			"~/bin/python /tmp/coreos/get-pip.py", 
			"sudo mv /tmp/coreos/runner ~/bin/pip && sudo chmod 0755 ~/bin/pip", 
			"sudo rm -rf /tmp/coreos" 
		] 
	} 
}

# Mesos agent network interface outputs
output "mesos_agent_network_interface_ids" {
	value = "${join(",", azurerm_network_interface.agent_network_interface.*.id)}"
}

output "mesos_agent_network_interface_macaddresses" {
	value = "${join(",", azurerm_network_interface.agent_network_interface.*.mac_address)}"
}

output "mesos_agent_network_interface_privateipaddresses" {
	value = "${join(",", azurerm_network_interface.agent_network_interface.*.private_ip_address)}"
}

output "mesos_agent_network_interface_virtualmachineids" {
	value = "${join(",", azurerm_network_interface.agent_network_interface.*.virtual_machine_id)}"
}

output "mesos_agent_network_interface_applieddnsservers" {
	value = "${join(",", azurerm_network_interface.agent_network_interface.*.applied_dns_servers)}"
}

output "mesos_agent_network_interface_internalfqdns" {
	value = "${join(",", azurerm_network_interface.agent_network_interface.*.internal_fqdn)}"
}

# Mesos agent virtual machine outputs
output "mesos_agent_virtual_machine_ids" {
	value = "${join(",", azurerm_virtual_machine.mesos_agent.*.id)}"
}