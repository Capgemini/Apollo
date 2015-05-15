output "master.1.ip" {
  value = "${aws_instance.mesos-master.0.public_ip}"
}
output "slave_ips" {
   value = "${join(",", aws_instance.mesos-slave.*.public_ip)}"
}
output "elb.hostname" {
  value = "${aws_elb.app.dns_name}"
}
