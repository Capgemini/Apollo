/* Mesos master instances */
resource "aws_instance" "mesos-master" {
  instance_type = "${var.instance_type.master}"
  ami = "${atlas_artifact.mesos.metadata_full.region-eu-west-1}"
  count = "${var.masters}"
  key_name = "${var.key_name}"
  source_dest_check = false
  subnet_id = "${aws_subnet.private.id}"
  security_groups   = ["${aws_security_group.default.id}", "${aws_security_group.master.id}"]
  user_data = "${file(\"files/setup-master.sh\")}"
  tags = {
    Name = "capgemini-mesos-master-${count.index}"
  }
}
