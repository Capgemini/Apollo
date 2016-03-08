module "slave_amitype" {
  source        = "github.com/terraform-community-modules/tf_aws_virttype"
  instance_type = "${var.slave_instance_type}"
}

module "slave_ami" {
  source   = "github.com/terraform-community-modules/tf_aws_coreos_ami"
  region   = "${var.region}"
  channel  = "${var.coreos_channel}"
  virttype = "${module.slave_amitype.prefer_hvm}"
}

resource "template_file" "slave_cloud_init" {
  template   = "slave-cloud-config.yml.tpl"
  depends_on = ["template_file.etcd_discovery_url"]
  vars {
    etcd_discovery_url = "${file(var.etcd_discovery_url_file)}"
    size               = "${var.masters + var.slaves}"
  }
}

resource "aws_instance" "mesos-slave" {
  instance_type     = "${var.slave_instance_type}"
  ami               = "${module.slave_ami.ami_id}"
  count             = "${var.slaves}"
  key_name          = "${module.aws-keypair.keypair_name}"
  subnet_id         = "${element(split(",", module.public_subnet.subnet_ids), count.index)}"
  source_dest_check = false
  security_groups   = ["${module.sg-default.security_group_id}"]
  depends_on        = ["aws_instance.mesos-master"]
  user_data         = "${template_file.slave_cloud_init.rendered}"
  tags = {
    Name = "apollo-mesos-slave-${count.index}"
    role = "mesos_slaves"
  }
  ebs_block_device {
    device_name           = "/dev/xvdb"
    volume_size           = "${var.slave_ebs_volume_size}"
    delete_on_termination = true
  }
}
