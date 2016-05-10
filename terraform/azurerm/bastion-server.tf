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
		disable_password_authentication = true
		
		ssh_keys {
			path = "/home/${var.bastion_server_username}/.ssh/authorized_keys"
			key_data = "${file("${var.ssh_public_key_file}")}" # openssh format 
		}
	}

	connection {
		host = "${azurerm_public_ip.bastion_publicip.ip_address}"
		user = "${var.bastion_server_username}"
		private_key = "${file("${var.ssh_private_key_file}")}" # openssh format 
	}

	provisioner "remote-exec" {
		inline = [
				  "sudo iptables -t nat -A POSTROUTING -j MASQUERADE",
				  "echo 1 | sudo tee /proc/sys/net/ipv4/conf/all/forwarding",
				  /* Install docker */
				  /* Add the repository to your APT sources */
				  "sudo -E sh -c 'echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list'",
				  /* Then import the repository key */
				  "sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D",
				  "sudo apt-get update",
				  /* Install docker-engine */
				  "sudo apt-get install -y docker-engine=${var.docker_version}",
				  "sudo service docker start",
				  /* Initialize open vpn data container */
				  "sudo mkdir -p /etc/openvpn",
				  "sudo docker run --name ovpn-data -v /etc/openvpn busybox",
				  /* Generate OpenVPN server config */
				  "sudo docker run --volumes-from ovpn-data --rm gosuri/openvpn ovpn_genconfig -p ${var.vn_cidr_block} -u udp://${azurerm_public_ip.bastion_publicip.id}"
				] 
	}
}