/* Base packer build we use for provisioning slave instances */
resource "atlas_artifact" "mesos-slave" {
  name = "${var.atlas_artifact.slave}"
  type = "aws.ami"
}

/* Mesos slave instances */
resource "aws_instance" "mesos-slave" {
  instance_type     = "${var.instance_type.slave}"
  ami               = "${element(atlas_artifact.mesos-slave.metadata_full.*, concat("region-", var.region)) }"
  count             = "${var.slaves}"
  key_name          = "${var.key_name}"
  source_dest_check = false
  subnet_id         = "${aws_subnet.private.id}"
  security_groups   = ["${aws_security_group.default.id}"]
  depends_on        = ["aws_instance.nat", "aws_internet_gateway.public", "aws_instance.mesos-master"]
  tags = {
    Name = "capgemini-mesos-slave-${count.index}"
  }
  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = "${var.slave_block_device.volume_size}"
    delete_on_termination = true
  }
  connection {
    user        = "ubuntu"
    key_file    = "${var.key_file}"
    host        = "${aws_eip.nat.public_ip}"
    script_path = "/tmp/${self.id}.sh"
  }
  provisioner "file" {
    source      = "${path.module}/scripts/common.sh"
    destination = "/tmp/${self.id}-00common.sh"
  }
  provisioner "file" {
    source      = "${path.module}/scripts/setup-slave.sh"
    destination = "/tmp/${self.id}-01setup-slave.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "echo main ${self.private_ip} ${self.private_dns} ${var.atlas_token} ${var.atlas_infrastructure} ${var.region} | cat /tmp/${self.id}-*.sh - | bash"
    ]
  }
}
