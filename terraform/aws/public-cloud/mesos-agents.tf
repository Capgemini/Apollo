module "agent_amitype" {
  source        = "github.com/terraform-community-modules/tf_aws_virttype"
  instance_type = "${var.agent_instance_type}"
}

module "agent_ami" {
  source   = "github.com/terraform-community-modules/tf_aws_coreos_ami"
  region   = "${var.region}"
  channel  = "${var.coreos_channel}"
  virttype = "${module.agent_amitype.prefer_hvm}"
}

module "traefik-ca" {
  source            = "github.com/Capgemini/tf_tls//ca"
  organization      = "${var.organization}"
  ca_count          = "${var.agents}"
  ip_addresses_list = "${concat(aws_instance.mesos-agent.*.public_ip)}"
  ssh_user          = "core"
  ssh_private_key   = "${file(var.private_key_file)}"
  target_folder     = "/etc/traefik/ssl"
}

resource "template_file" "agent_cloud_init" {
  template   = "agent-cloud-config.yml.tpl"
  depends_on = ["template_file.etcd_discovery_url"]
  vars {
    etcd_discovery_url = "${file(var.etcd_discovery_url_file)}"
    size               = "${var.masters}"
    region             = "${var.region}"
  }
}

resource "aws_instance" "mesos-agent" {
  instance_type     = "${var.agent_instance_type}"
  ami               = "${module.agent_ami.ami_id}"
  count             = "${var.agents}"
  key_name          = "${module.aws-keypair.keypair_name}"
  subnet_id         = "${element(split(",", module.public_subnet.subnet_ids), count.index)}"
  source_dest_check = false
  security_groups   = ["${module.sg-default.security_group_id}"]
  depends_on        = ["aws_instance.mesos-master"]
  user_data         = "${template_file.agent_cloud_init.rendered}"
  tags = {
    Name = "apollo-mesos-agent-${count.index}"
    role = "mesos_agents"
  }
  ebs_block_device {
    device_name           = "/dev/xvdb"
    volume_size           = "${var.agent_ebs_volume_size}"
    delete_on_termination = true
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
      "sudo rm -rf /tmp/coreos"
    ]
  }
}
