resource "aws_instance" "mesos-master" {
  instance_type = "${var.instance_type.master}"
  ami = "${atlas_artifact.mesos.metadata_full.region-eu-west-1}"
  count = 1
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.mesos-sg.name}"]
  connection {
    user = "ubuntu"
    key_file = "${var.key_file}"
  }
  provisioner "remote-exec" {
    scripts = [
      "../files/setup-master.sh"
    ]
  }
}

resource "aws_route53_record" "mesos-master" {
   zone_id = "${var.zone_id}"
   name = "${var.mesos_dns}"
   type = "A"
   ttl = "300"
   records = ["${aws_instance.mesos-master.public_ip}"]
}
