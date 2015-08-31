/* Base packer build we use for provisioning master instances */
resource "atlas_artifact" "mesos-master" {
  name    = "${var.atlas_artifact.master}"
  type    = "aws.ami"
  version = "${var.atlas_artifact_version.master}"
}

/* Mesos master instances */
resource "aws_instance" "mesos-master" {
  instance_type     = "${var.instance_type.master}"
  ami               = "${lookup(atlas_artifact.mesos-master.metadata_full, concat("region-", var.region))}"
  count             = "${var.masters}"
  key_name          = "${aws_key_pair.deployer.key_name}"
  source_dest_check = false
  subnet_id         = "${element(aws_subnet.private.*.id, count.index)}"
  security_groups   = ["${aws_security_group.default.id}"]
  depends_on        = ["aws_instance.bastion", "aws_internet_gateway.public"]
  tags = {
    Name = "apollo-mesos-master-${count.index}"
    role = "mesos_masters"
  }
  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = "${var.block_device.volume_size}"
    delete_on_termination = true
  }
  provisioner "remote-exec" {
    script = "mount.sh"
    connection {
      user = "ubuntu"
    }
  }
}
