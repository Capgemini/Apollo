# Bastion server
module "bastion_amitype" {
  source        = "github.com/terraform-community-modules/tf_aws_virttype"
  instance_type = "${var.bastion_instance_type}"
}

module "bastion_ami" {
  source   = "github.com/terraform-community-modules/tf_aws_coreos_ami"
  region   = "${var.region}"
  channel  = "${var.coreos_channel}"
  virttype = "${module.bastion_amitype.prefer_hvm}"
}

resource "template_file" "bastion_cloud_init" {
  template   = "bastion-cloud-config.yml.tpl"
  depends_on = ["template_file.etcd_discovery_url"]
  vars {
    etcd_discovery_url = "${file(var.etcd_discovery_url_file)}"
    size               = "${var.masters}"
    vpc_cidr_block     = "${var.vpc_cidr_block}"
    region             = "${var.region}"
  }
}

resource "aws_instance" "bastion" {
  instance_type     = "${var.bastion_instance_type}"
  ami               = "${module.bastion_ami.ami_id}"
  # Just put the bastion in the first public subnet
  subnet_id         = "${element(split(",", module.vpc.public_subnets), 0)}"
  # @todo - this allows bastion connection on any port which is not ideal but was like this previously.
  security_groups   = ["${module.sg-default.security_group_id}", "${aws_security_group.bastion.id}"]
  key_name          = "${module.aws-keypair.keypair_name}"
  source_dest_check = false
  user_data         = "${template_file.bastion_cloud_init.rendered}"
  tags = {
    Name = "apollo-mesos-bastion"
    role = "bastion"
  }
  connection {
    user        = "core"
    private_key = "${var.private_key_file}"
  }

  # Do some early bootstrapping of the CoreOS machines. This will install
  # python and pip so we can use as the ansible_python_interpreter in our playbooks
  provisioner "file" {
    source      = "../../scripts/coreos"
    destination = "/tmp"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod -R +x /tmp/coreos",
      "/tmp/coreos/bootstrap.sh",
      "~/bin/python /tmp/coreos/get-pip.py",
      "sudo mv /tmp/coreos/runner ~/bin/pip && sudo chmod 0755 ~/bin/pip",
      "sudo rm -rf /tmp/coreos",
      /* Initialize open VPN container and server config */
      "sudo iptables -t nat -A POSTROUTING -j MASQUERADE",
      "sudo docker run --name ovpn-data -v /etc/openvpn busybox",
      "sudo docker run --volumes-from ovpn-data --rm gosuri/openvpn ovpn_genconfig -p ${var.vpc_cidr_block} -u udp://${aws_instance.bastion.public_ip}"
    ]
  }
}

# Bastion elastic IP
resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc      = true
}
