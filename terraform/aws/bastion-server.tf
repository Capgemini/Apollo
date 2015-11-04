resource "aws_key_pair" "deployer" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.key_file)}"
}

/*
   Terraform module to get the current set of publicly available ubuntu AMIs.
   https://github.com/terraform-community-modules/tf_aws_ubuntu_ami
*/
module "ami_bastion" {
  source = "github.com/terraform-community-modules/tf_aws_ubuntu_ami/ebs"
  region = "${var.region}"
  distribution = "trusty"
  instance_type = "${var.bastion_instance_type}"
}

/* NAT/VPN server */
resource "aws_instance" "bastion" {
  ami               = "${module.ami_bastion.ami_id}"
  instance_type     = "${var.bastion_instance_type}"
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
      "sudo docker run --volumes-from ovpn-data --rm gosuri/openvpn ovpn_genconfig -p ${var.vpc_cidr_block} -u udp://${aws_instance.bastion.public_ip}"
    ]
  }
}

/* NAT elastic IP */
resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc = true
}
