resource "aws_key_pair" "deployer" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.key_file)}"
}

/* NAT/VPN server */
resource "aws_instance" "bastion" {
  ami               = "${lookup(var.amis, var.region)}"
  instance_type     = "t2.micro"
  subnet_id         = "${aws_subnet.public.id}"
  security_groups   = ["${aws_security_group.default.id}", "${aws_security_group.bastion.id}"]
  depends_on        = ["aws_internet_gateway.public", "aws_key_pair.deployer"]
  key_name          = "${aws_key_pair.deployer.key_name}"
  source_dest_check = false
  tags = {
    Name = "apollo-mesos-bastion"
    role = "bastion"
  }
  connection {
    user     = "ubuntu"
    key_file = "${var.private_key_file}"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo iptables -t nat -A POSTROUTING -j MASQUERADE",
      "echo 1 | sudo tee /proc/sys/net/ipv4/conf/all/forwarding",
      /* Install docker */
      "curl -sSL https://get.docker.com/ubuntu/ | sudo sh",
      "sudo service docker start",
      /* Initialize open vpn data container */
      "sudo mkdir -p /etc/openvpn",
      "sudo docker run --name ovpn-data -v /etc/openvpn busybox",
      /* Generate OpenVPN server config */
      "sudo docker run --volumes-from ovpn-data --rm gosuri/openvpn ovpn_genconfig -p ${var.vpc_cidr_block} -u udp://${aws_instance.bastion.public_ip}"
    ]
  }
}

/* NAT elastic IP */
resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc = true
}
