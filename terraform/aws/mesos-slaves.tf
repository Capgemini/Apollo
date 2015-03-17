resource "aws_instance" "mesos-slave" {
  instance_type = "${var.instance_type.slave}"
  ami = "${atlas_artifact.mesos.metadata_full.region-eu-west-1}"
  count = "${var.slaves}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.mesos-sg.name}"]
  connection {
    user = "ubuntu"
    key_file = "${var.key_file}"
  }
  provisioner "remote-exec" {
    inline = [
      "echo ${aws_instance.mesos-master.private_ip} > /tmp/zk_master"
    ]
  }
  provisioner "remote-exec" {
    scripts = [
      "../files/setup-slave.sh"
    ]
  }
}
