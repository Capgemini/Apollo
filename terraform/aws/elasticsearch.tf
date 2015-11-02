resource "atlas_artifact" "elasticsearch" {
  name = "${var.atlas_artifact.master}"
  version = "${var.atlas_artifact_version.master}"
  type = "aws.ami"
}

resource "aws_instance" "elasticsearch" {
  instance_type     = "${var.instance_type.master}"
  /* waiting for https://github.com/hashicorp/terraform/issues/2731 so we don't have to hard-code the region */
  ami               = "${atlas_artifact.elasticsearch.metadata_full.ami_id}"
  count             = "1"
  source_dest_check = false
  subnet_id         = "${aws_subnet.private.0.id}"
  security_groups   = ["${aws_security_group.default.id}"]
  depends_on        = ["aws_eip.bastion", "aws_internet_gateway.public"]
  key_name          = "${aws_key_pair.deployer.key_name}"
  tags = {
    Name = "apollo-elasticsearch-${count.index}"
    role = "elasticsearch"
    monitoring = "datadog"
  }
  ebs_block_device {
    device_name = "/dev/sde"
    volume_size = "${var.elasticsearch_block_device.volume_size}"
    volume_type = "gp2"
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
      "sudo mkdir /mnt/es",
      "sudo mkfs -t ext4 /dev/xvde",
      "sudo mount /dev/xvde /mnt/es",
      "echo '/dev/xvde	/mnt/es	ext4	defaults,nofail,nobootwait	0	2' | sudo tee -a /etc/fstab"
    ]
  }
}
