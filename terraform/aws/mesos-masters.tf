/* Base packer build we use for provisioning master instances */
resource "atlas_artifact" "mesos-master" {
  name = "${var.atlas_artifact.master}"
  type = "aws.ami"
}

/* Mesos master instances */
resource "aws_instance" "mesos-master" {
  instance_type     = "${var.instance_type.master}"
  ami               = "${atlas_artifact.mesos-master.metadata_full.region-eu-west-1}"
  count             = "${var.masters}"
  key_name          = "${var.key_name}"
  source_dest_check = false
  subnet_id         = "${aws_subnet.private.id}"
  security_groups   = ["${aws_security_group.default.id}"]
  depends_on        = ["aws_instance.nat", "aws_internet_gateway.public"]
  private_ip        = "${lookup(var.master_ips, concat("master-", count.index))}"
  tags = {
    Name = "capgemini-mesos-master-${count.index}"
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
    source      = "${path.module}/scripts/setup-master.sh"
    destination = "/tmp/${self.id}-01setup-master.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "echo main ${lookup(var.master_ips, concat("master-", count.index))} ${self.private_dns} ${var.atlas_token} ${var.atlas_infrastructure} | cat /tmp/${self.id}-*.sh - | bash"
    ]
  }
}
