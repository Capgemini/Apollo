/* Base packer build we use for provisioning slave instances */
resource "atlas_artifact" "nat" {
  name = "${var.atlas_artifact.nat}"
  type = "aws.ami"
}

/* NAT/VPN server */
resource "aws_instance" "nat" {
  ami               = "${replace(atlas_artifact.nat.id, concat(var.region, ":"), "")}"
  instance_type     = "${var.instance_type.nat}"
  subnet_id         = "${aws_subnet.public.id}"
  security_groups   = ["${aws_security_group.default.id}", "${aws_security_group.nat.id}"]
  depends_on        = ["aws_internet_gateway.public"]
  key_name          = "${var.key_name}"
  source_dest_check = false
  tags = {
    Name = "apollo-mesos-nat"
    role = "nat"
  }
  connection {
    user       = "ubuntu"
    key_file   = "${var.key_file}"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo iptables -t nat -A POSTROUTING -j MASQUERADE",
      "echo 1 | sudo tee /proc/sys/net/ipv4/conf/all/forwarding",
      /* Enable docker */
      "sudo rm -f /etc/init/docker.override",
      "sudo service docker start",
      /* Initialize open vpn data container */
      "sudo mkdir -p /etc/openvpn",
      "sudo docker run --name ovpn-data -v /etc/openvpn busybox",
      /* Generate OpenVPN server config */
      "sudo docker run --volumes-from ovpn-data --rm gosuri/openvpn ovpn_genconfig -p ${var.vpc_cidr_block} -u udp://${aws_instance.nat.public_ip}"
    ]
  }
}

/* NAT elastic IP */
resource "aws_eip" "nat" {
  instance = "${aws_instance.nat.id}"
  vpc = true
}
