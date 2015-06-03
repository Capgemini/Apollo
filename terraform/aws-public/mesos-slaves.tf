/* Base packer build we use for provisioning slave instances */
resource "atlas_artifact" "mesos-slave" {
  name = "${var.atlas_artifact.slave}"
  type = "aws.ami"
}

/* Mesos slave instances */
resource "aws_instance" "mesos-slave" {
  instance_type     = "${var.instance_type.slave}"
  ami               = "${replace(atlas_artifact.mesos-master.id, concat(var.region, ":"), "")}"
  count             = "${var.slaves}"
  key_name          = "${var.key_name}"
  subnet_id         = "${aws_subnet.public.id}"
  source_dest_check = false
  security_groups   = ["${aws_security_group.default.id}"]
  depends_on        = ["aws_instance.mesos-master"]
  tags = {
    Name = "apollo-mesos-slave-${count.index}"
    role = "mesos_slaves"
  }
  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = "${var.slave_block_device.volume_size}"
    delete_on_termination = true
  }
}
