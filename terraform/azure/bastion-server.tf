resource "azure_hosted_service" "bastion-service" {
  name               = "bastion-server"
  location           = "${var.region}"
  ephemeral_contents = false
  description        = "Mesos master service"
  label              = "bastion-service"
  provisioner "local-exec" {
    command = "./azure-upload-certificate.sh bastion-server"
  }
}

/* NAT/VPN server */
resource "azure_instance" "bastion" {
  name                 = "apollo-bastion"
  hosted_service_name  = "${azure_hosted_service.bastion-service.name}"
  description          = "bastion"
  image                = "Ubuntu Server 14.04 LTS"
  size                 = "${var.instance_type.master}"
  storage_service_name = "${azure_storage_service.azure_mesos_storage.name}"
  security_group       = "${azure_security_group.bastion.name}"
  virtual_network      = "${azure_virtual_network.virtual-network.id}"
  subnet               = "public"
  location             = "${var.region}"
  username             = "${var.username}"
  ssh_key_thumbprint   = "${file("ssh_thumbprint")}"

  endpoint {
    name         = "SSH"
    protocol     = "tcp"
    public_port  = 22
    private_port = 22
  }

  endpoint {
    name         = "OpenVPN"
    protocol     = "udp"
    public_port  = 1194
    private_port = 1194
  }

  endpoint {
    name         = "HTTPS"
    protocol     = "tcp"
    public_port  = 443
    private_port = 443
  }

  endpoint {
    name         = "HTTP"
    protocol     = "tcp"
    public_port  = 80
    private_port = 80
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
      "sudo docker run --volumes-from ovpn-data --rm gosuri/openvpn ovpn_genconfig -p ${var.vn_cidr_block} -u udp://${azure_instance.bastion.vip_address}"
    ]
  }
}
