# Create a network interface for bastion server
resource "azurerm_network_interface" "bastion_network_interface" {
	name = "Bastion_NetworkInterface"
	location = "${var.region}"
	resource_group_name = "${azurerm_resource_group.resource_group.name}"
	network_security_group_id = "${azurerm_network_security_group.bastion_security_group.id}"

	ip_configuration {
		name = "bastionipconfiguration"
		subnet_id = "${element(azurerm_subnet.public.*.id, 0)}"
		private_ip_address_allocation = "dynamic"
		public_ip_address_id = "${azurerm_public_ip.bastion_publicip.id}"
	}
}

# User profile template
resource "template_file" "bastion_cloud_init" { 
	template = "${file("bastion-cloud-config.yml.tpl")}" 
	depends_on = ["template_file.etcd_discovery_url"] 
	vars { 
		etcd_discovery_url = "${file(var.etcd_discovery_url_file)}" 
		size = "${var.master_count}" 
		vpc_cidr_block = "${var.vpc_cidr_block}" 
		region = "${var.region}" 
	} 
}

# NAT/VPN server
resource "azurerm_virtual_machine" "bastion" {
	name = "apollo-bastion"
	location = "${var.region}"
	resource_group_name = "${azurerm_resource_group.resource_group.name}"
	network_interface_ids = ["${azurerm_network_interface.bastion_network_interface.id}"]
	vm_size = "${var.instance_type.bastion}"

	storage_image_reference {
		publisher = "${var.artifact_bastion.publisher}"
		offer = "${var.artifact_bastion.offer}"
		sku = "${var.artifact_bastion.sku}"
		version = "${var.artifact_bastion.version}"	
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
		custom_data = "${base64encode(template_file.bastion_cloud_init.rendered)}"
	}

	os_profile_linux_config {
		disable_password_authentication = true
		
		ssh_keys {
			path = "/home/${var.bastion_server_username}/.ssh/authorized_keys"
			key_data = "${file("${var.ssh_public_key_file}")}" # openssh format 
		}
	}

	tags { 
		Name = "apollo-mesos-bastion" 
     		role = "bastion" 
	} 

	connection {
		host = "${azurerm_public_ip.bastion_publicip.ip_address}"
		user = "${var.bastion_server_username}"
		private_key = "${file("${var.ssh_private_key_file}")}" # openssh format 
	}

	# Do some early bootstrapping of the CoreOS machines. This will install
	# python and pip so we can use as the ansible_python_interpreter in our playbooks
	provisioner "file" { 
		source	= "coreos" 
		destination = "/tmp" 
	}

	provisioner "remote-exec" {
    	inline = [
     		"sudo chmod -R +x /tmp/coreos",
      		"/tmp/coreos/bootstrap.sh",
      		"~/bin/python /tmp/coreos/get-pip.py",
      		"sudo mv /tmp/coreos/runner ~/bin/pip && sudo chmod 0755 ~/bin/pip",
      		"sudo rm -rf /tmp/coreos",
      
			# Initialize open VPN container and server config     
			"sudo iptables -t nat -A POSTROUTING -j MASQUERADE",
      		"sudo docker run --name ovpn-data -v /etc/openvpn busybox",
      		"sudo docker run --volumes-from ovpn-data --rm gosuri/openvpn ovpn_genconfig -p ${var.vpc_cidr_block} -u udp://${azurerm_public_ip.bastion_publicip.ip_address}"
		]
	} 
}

# Bastion network interface outputs
output "bastion_network_interface_id" {
	value = "${azurerm_network_interface.bastion_network_interface.id}"
}

output "bastion_network_interface_macaddress" {
	value = "${azurerm_network_interface.bastion_network_interface.mac_address}"
}

output "bastion_network_interface_privateipaddress" {
	value = "${azurerm_network_interface.bastion_network_interface.private_ip_address}"
}

output "bastion_network_interface_virtualmachineid" {
	value = "${azurerm_network_interface.bastion_network_interface.virtual_machine_id}"
}

output "bastion_network_interface_applieddnsservers" {
	value = "${azurerm_network_interface.bastion_network_interface.applied_dns_servers}"
}

output "bastion_network_interface_internalfqdn" {
    value = "${azurerm_network_interface.bastion_network_interface.internal_fqdn}"
}

# Bastion virtual machine outputs
output "bastion_virtual_machine_id" {
	value = "${azurerm_virtual_machine.bastion.id}"
}