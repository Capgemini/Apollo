/* Base packer build we use for provisioning master instances */
resource "atlas_artifact" "mesos-master" {
  name = "${var.atlas_artifact.master}"
  type = "aws.ami"
}

/* Mesos master instances */
resource "aws_instance" "mesos-master" {
  instance_type = "${var.instance_type.master}"
  ami = "${atlas_artifact.mesos-master.metadata_full.region-eu-west-1}"
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
