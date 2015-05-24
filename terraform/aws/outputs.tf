output "nat.ip" {
  value = "${aws_eip.nat.public_ip}"
}
output "master.1.ip" {
  value = "${aws_instance.mesos-master.0.private_ip}"
}
output "master_ips" {
   value = "${join(",", aws_instance.mesos-master.*.private_ip)}"
}
output "slave_ips" {
   value = "${join(",", aws_instance.mesos-slave.*.private_ip)}"
}
output "elb.hostname" {
  value = "${aws_elb.app.dns_name}"
}
