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
  template   = "cloud-config.yml.tpl"
  depends_on = ["template_file.etcd_discovery_url"]
  vars {
    etcd_discovery_url = "${file(var.etcd_discovery_url_file)}"
    size               = "${var.masters + var.slaves}"
  }
}

resource "aws_instance" "mesos-master" {
  instance_type     = "${var.master_instance_type}"
  ami               = "${module.master_ami.ami_id}"
  count             = "${var.masters}"
  key_name          = "${module.aws-keypair.keypair_name}"
  source_dest_check = false
  subnet_id         = "${element(split(",", module.vpc.private_subnets), count.index)}"
  security_groups   = ["${module.sg-default.security_group_id}"]
  depends_on        = ["aws_instance.bastion"]
  user_data         = "${template_file.master_cloud_init.rendered}"
  tags = {
    Name = "apollo-mesos-master-${count.index}"
    role = "mesos_masters"
  }
}
