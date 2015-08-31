/* Base packer build we use for provisioning slave instances */
resource "atlas_artifact" "mesos-slave" {
  name    = "${var.atlas_artifact.slave}"
  type    = "aws.ami"
  version = "${var.atlas_artifact_version.master}"
}

/* Mesos slave instances */
resource "aws_instance" "mesos-slave" {
  instance_type     = "${var.instance_type.slave}"
  ami               = "${lookup(var.amis, var.region)}"
  count             = "${var.slaves}"
  key_name          = "${aws_key_pair.deployer.key_name}"
  subnet_id         = "${element(aws_subnet.public.*.id, count.index)}"
  source_dest_check = false
  security_groups   = ["${aws_security_group.default.id}"]
  depends_on        = ["aws_instance.mesos-master"]
  tags = {
    Name = "apollo-mesos-slave-${count.index}"
    role = "mesos_slaves"
  }
  root_block_device {
    volume_size           = "${var.slave_root_device.volume_size}"
    volume_type           = "gp2"
    delete_on_termination = true
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
