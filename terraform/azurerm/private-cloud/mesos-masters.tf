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
	}
}

# Master server
resource "azurerm_virtual_machine" "mesos_master" {
	name = "apollo-mesos-master-${count.index}"
	count = "${var.master_count}"
	location = "${var.region}"
	availability_set_id = "${azurerm_availability_set.master.id}"
	depends_on = ["azurerm_virtual_machine.bastion"]
	resource_group_name = "${azurerm_resource_group.resource_group.name}"
	network_interface_ids = ["${element(azurerm_network_interface.master_network_interface.*.id, count.index)}"] 
	vm_size = "${var.instance_type.master}"

	storage_image_reference {
		publisher = "${var.artifact_master.publisher}"
		offer = "${var.artifact_master.offer}"
		sku = "${var.artifact_master.sku}"
		version = "${var.artifact_master.version}"
	}

	storage_os_disk {
		name = "masterdisk${count.index}"
		vhd_uri = "${azurerm_storage_account.storage_account.primary_blob_endpoint}${azurerm_storage_container.storage_container.name}/masterdisk-${count.index}.vhd"
		caching = "ReadWrite"
		create_option = "FromImage"
	}

	os_profile {
		computer_name = "apollo-mesos-master-${count.index}"
		admin_username = "${var.master_server_username}"
		admin_password = "${var.master_server_password}"
	}

	os_profile_linux_config {
		disable_password_authentication = true
		
		ssh_keys {
			path = "/home/${var.master_server_username}/.ssh/authorized_keys"
			key_data = "${file("${var.ssh_public_key_file}")}" # openssh format 
		}
	}

	tags { 
     		Name = "apollo-mesos-master-${count.index}" 
     		role = "mesos_masters" 
   	}

   	connection { 
     		user = "${var.master_server_username}" 
		host = "${element(azurerm_network_interface.master_network_interface.*.private_ip_address, count.index)}"
     		private_key = "${file("${var.ssh_private_key_file}")}" # openssh format
     		bastion_host = "${azurerm_public_ip.bastion_publicip.ip_address}"
		bastion_user = "${var.bastion_server_username}"
     		bastion_private_key = "${file("${var.ssh_private_key_file}")}" # openssh format
	}
	
	# Do some early bootstrapping of the CoreOS machines. This will install 
   	# python and pip so we can use as the ansible_python_interpreter in our playbooks 
   	provisioner "file" {
    
		source = "coreos"

    		destination = "/tmp"
  
	}
  

	# provisioner "file" { 
     	#	source      = "../../scripts/coreos" 
     	#	destination = "/tmp" 
   	# } 

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

# Mesos master network interface outputs
output "mesos_master_network_interface_ids" {
	value = "${join(",", azurerm_network_interface.master_network_interface.*.id)}"
}

output "mesos_master_network_interface_macaddresses" {
	value = "${join(",", azurerm_network_interface.master_network_interface.*.mac_address)}"
}

output "mesos_master_network_interface_privateipaddresses" {
	value = "${join(",", azurerm_network_interface.master_network_interface.*.private_ip_address)}"
}

output "mesos_master_network_interface_virtualmachineids" {
	value = "${join(",", azurerm_network_interface.master_network_interface.*.virtual_machine_id)}"
}

output "mesos_master_network_interface_applieddnsservers" {
	value = "${join(",", azurerm_network_interface.master_network_interface.*.applied_dns_servers)}"
}

output "mesos_master_network_interface_internalfqdns" {
	value = "${join(",", azurerm_network_interface.master_network_interface.*.internal_fqdn)}"
}

# Mesos master virtual machine outputs
output "mesos_master_virtual_machine_ids" {
	value = "${join(",", azurerm_virtual_machine.mesos_master.*.id)}"
}