output "nat.ip" {
  value = "${aws_eip.nat.public_ip}"
}
output "master.0.ip" {
  value = "${aws_instance.mesos-master.0.private_ip}"
}
