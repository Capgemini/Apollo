/* Base packer build we use for provisioning slave instances */
resource "atlas_artifact" "mesos-slave" {
  name = "${var.atlas_artifact.slave}"
  type = "aws.ami"
}

/* Mesos slave instances */
resource "aws_instance" "mesos-slave" {
  instance_type = "${var.instance_type.slave}"
  ami = "${atlas_artifact.mesos-slave.metadata_full.region-eu-west-1}"
  count = "${var.slaves}"
  key_name = "${var.key_name}"
  security_groups   = ["${aws_security_group.default.id}", "${aws_security_group.slave.id}"]
  key_name = "${var.key_name}"
  source_dest_check = false
  subnet_id = "${aws_subnet.private.id}"
  security_groups   = ["${aws_security_group.default.id}", "${aws_security_group.slave.id}"]
  user_data = "${file(\"files/setup-slave.sh\")}"
  tags = {
    Name = "capgemini-mesos-slave-${count.index}"
  }

  block_device {
    device_name           = "/dev/sdb"
    volume_size           = "${var.slave_block_device.volume_size}"
    delete_on_termination = true
  }
}
