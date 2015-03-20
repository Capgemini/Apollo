/* NAT/VPN server */
resource "aws_instance" "nat" {
  ami               = "${lookup(var.amis, var.region)}"
  instance_type     = "t2.micro"
  subnet_id         = "${aws_subnet.public.id}"
  security_groups   = ["${aws_security_group.default.id}", "${aws_security_group.nat.id}"]
  depends_on        = ["aws_internet_gateway.public"]
  key_name          = "${var.key_name}"
  source_dest_check = false
  tags = {
    Name = "capgemini-mesos-nat"
  }
  connection {
    user       = "ubuntu"
    key_file   = "${var.key_file}"
  }
  provisioner "file" {
    source      = "${var.key_file}"
    destination = "/home/ubuntu/.ssh/ec2-key.pem"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/ubuntu/.ssh/ec2-key.pem",
      "echo \"Host ip-*\"                                      >> /home/ubuntu/.ssh/config",
      "echo \"    IdentityFile /home/ubuntu/.ssh/ec2-key.pem\" >> /home/ubuntu/.ssh/config",
      "echo \"    StrictHostKeyChecking no\"                   >> /home/ubuntu/.ssh/config",
      "echo \"    UserKnownHostsFile=/dev/null\"               >> /home/ubuntu/.ssh/config",
      "echo \"    LogLevel ERROR\"                             >> /home/ubuntu/.ssh/config",
      /* @todo - look this up a bit more dynamically */
      "echo ${var.master_ips.master-0} >> /home/ubuntu/masters",
      "echo ${var.master_ips.master-1} >> /home/ubuntu/masters",
      "echo ${var.master_ips.master-2} >> /home/ubuntu/masters"
    ]
  }
  provisioner "remote-exec" {
    inline = [
      /* @todo - not sure the routing is working correctly here */
      "sudo iptables -t nat -A POSTROUTING -j MASQUERADE",
      "echo 1 | sudo tee /proc/sys/net/ipv4/conf/all/forwarding",
      /* Install docker */
      "curl -sSL https://get.docker.com/ubuntu/ | sudo sh",
      /* Initialize open vpn data container */
      "sudo mkdir -p /etc/openvpn",
      "sudo docker run --name ovpn-data -v /etc/openvpn busybox",
      /* Generate OpenVPN server config */
      "sudo docker run --volumes-from ovpn-data --rm gosuri/openvpn ovpn_genconfig -p ${var.vpc_cidr_block} -u udp://${aws_instance.nat.public_ip}"
    ]
  }
}

resource "aws_eip" "nat" {
  instance = "${aws_instance.nat.id}"
  vpc = true
}
