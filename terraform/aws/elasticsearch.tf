resource "atlas_artifact" "elasticsearch" {
  name = "${var.atlas_artifact.master}"
  type = "aws.ami"
}

resource "aws_instance" "elasticsearch" {
  instance_type     = "${var.instance_type.master}"
  ami               = "${replace(atlas_artifact.elasticsearch.id, concat(var.region, ":"), "")}"
  count             = "1"
  key_name          = "${var.key_name}"
  source_dest_check = false
  subnet_id         = "${aws_subnet.private.id}"
  security_groups   = ["${aws_security_group.default.id}"]
  depends_on        = ["aws_instance.bastion", "aws_internet_gateway.public"]
  tags = {
    Name = "apollo-elasticsearch-${count.index}"
    role = "elasticsearch"
  }
  ebs_block_device {
    device_name = "/dev/sde"
    volume_size = "${var.elasticsearch_block_device.volume_size}"
    volume_type = "gp2"
    delete_on_termination = true
  }
  connection {
    user         = "ubuntu"
    key_file     = "${var.key_file}"
    bastion_host = "${aws_instance.bastion.public_ip}"
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
