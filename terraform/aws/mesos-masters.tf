/* Base packer build we use for provisioning master instances */
resource "atlas_artifact" "mesos-master" {
  name    = "${var.atlas_artifact.master}"
  version = "${var.atlas_artifact_version.master}"
  type    = "aws.ami"
}

/* Mesos master instances */
resource "aws_instance" "mesos-master" {
  instance_type     = "${var.instance_type.master}"
  /* waiting for https://github.com/hashicorp/terraform/issues/2731 so we don't have to hard-code the region */
  ami               = "${atlas_artifact.mesos-master.metadata_full.ami_id}"
  count             = "${var.masters}"
  key_name          = "${aws_key_pair.deployer.key_name}"
  source_dest_check = false
  subnet_id         = "${element(aws_subnet.private.*.id, count.index)}"
  security_groups   = ["${aws_security_group.default.id}"]
  depends_on        = ["aws_instance.bastion", "aws_internet_gateway.public"]
  tags = {
    Name = "apollo-mesos-master-${count.index}"
    role = "mesos_masters"
    monitoring = "datadog"
  }
  ebs_block_device {
    device_name = "/dev/xvdp"
    volume_type = "io1"
    volume_size = "${var.consul_block_device.volume_size}"
    iops = "${var.consul_block_device.iops}"
    delete_on_termination = true
  }
  connection {
    user         = "ubuntu"
    key_file     = "${var.private_key_file}"
    bastion_host = "${aws_eip.bastion.public_ip}"
    agent        = false
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mkfs -t ext4 /dev/xvdp",
      "sudo mkdir -p /mnt/consul",
      "sudo mount /dev/xvdp /mnt/consul",
      "echo '/dev/xvdp	/mnt/consul	ext4	defaults,nofail,nobootwait	0	2' | sudo tee -a /etc/fstab",
    ]
  }
}
