module "master_amitype" {
  source        = "github.com/terraform-community-modules/tf_aws_virttype"
  instance_type = "${var.master_instance_type}"
}

module "master_ami" {
  source   = "github.com/terraform-community-modules/tf_aws_coreos_ami"
  region   = "${var.region}"
  channel  = "${var.coreos_channel}"
  virttype = "${module.master_amitype.prefer_hvm}"
}

resource "template_file" "master_cloud_init" {
  template   = "master-cloud-config.yml.tpl"
  depends_on = ["template_file.etcd_discovery_url"]
  vars {
    etcd_discovery_url = "${file(var.etcd_discovery_url_file)}"
    size               = "${var.masters}"
    region             = "${var.region}"
  }
}

resource "aws_instance" "mesos-master" {
  instance_type     = "${var.master_instance_type}"
  ami               = "${module.master_ami.ami_id}"
  count             = "${var.masters}"
  key_name          = "${module.aws-keypair.keypair_name}"
  subnet_id         = "${element(split(",", module.public_subnet.subnet_ids), count.index)}"
  source_dest_check = false
  security_groups   = ["${module.sg-default.security_group_id}"]
  user_data         = "${template_file.master_cloud_init.rendered}"
  tags = {
    Name = "apollo-mesos-master-${count.index}"
    role = "mesos_masters"
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
