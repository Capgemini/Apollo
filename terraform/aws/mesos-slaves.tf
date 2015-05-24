/* Base packer build we use for provisioning slave instances */
resource "atlas_artifact" "mesos-slave" {
  name = "${var.atlas_artifact.slave}"
  type = "aws.ami"
}

/* Mesos slave instances */
resource "aws_instance" "mesos-slave" {
  instance_type     = "${var.instance_type.slave}"
  ami               = "${concat(atlas_artifact.mesos-master.metadata_full.region-, var.region)}"
  availability_zone = "${lookup(var.zones, concat("zone", count.index))}"
  count             = "${var.slaves}"
  key_name          = "${var.key_name}"
  source_dest_check = false
  subnet_id         = "${element(aws_subnet.private.*.id, count.index)}"
  security_groups   = ["${aws_security_group.default.id}"]
  depends_on        = ["aws_instance.nat", "aws_internet_gateway.public", "aws_instance.mesos-master"]
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
