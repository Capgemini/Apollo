resource "aws_key_pair" "deployer" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.key_file)}"
}

/*
   Terraform module to get the current set of publicly available ubuntu AMIs.
   https://github.com/terraform-community-modules/tf_aws_ubuntu_ami
module "ami_bastion" {
  source = "github.com/terraform-community-modules/tf_aws_ubuntu_ami/ebs"
  region = "${var.region}"
  distribution = "trusty"
  instance_type = "${var.bastion_instance_type}"
}
*/

resource "atlas_artifact" "bastion" {
  name    = "${var.atlas_artifact.master}"
  version = "${var.atlas_artifact_version.master}"
  type    = "aws.ami"
}

/* NAT/VPN server */
resource "aws_instance" "bastion" {
  ami               = "${atlas_artifact.bastion.metadata_full.ami_id}"
  instance_type     = "${var.bastion_instance_type}"
  subnet_id         = "${aws_subnet.public.1.id}"
  security_groups   = ["${aws_security_group.default.id}", "${aws_security_group.bastion.id}"]
  depends_on        = ["aws_internet_gateway.public", "aws_key_pair.deployer"]
  key_name          = "${aws_key_pair.deployer.key_name}"
  source_dest_check = false
  tags = {
    Name = "apollo-mesos-bastion"
    role = "bastion"
    monitoring = "datadog"
  }
  connection {
    user     = "ubuntu"
    key_file = "${var.private_key_file}"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo iptables -t nat -A POSTROUTING -j MASQUERADE",
      "echo 1 | sudo tee /proc/sys/net/ipv4/conf/all/forwarding",
      /* turn on docker */
      "sudo rm /etc/init/docker.override",
      "sudo service docker start",
      /* Initialize open vpn data container */
      "sudo mkdir -p /etc/openvpn",
      "sudo docker run --name ovpn-data -v /etc/openvpn busybox",
      /* Generate OpenVPN server config */
      "sudo docker run --volumes-from ovpn-data --rm gosuri/openvpn ovpn_genconfig -D -p 'route 10.0.0.0 255.0.0.0 vpn_gateway' -p \"dhcp-option DNS $(ec2metadata --local-ipv4)\" -p push \"dhcp-option DOMAIN service.consul\" -u udp://${aws_instance.bastion.public_ip}"
    ]
  }
}

/* NAT elastic IP */
resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc = true
}
