output "vpc_cidr_block.ip" {
  value = "${aws_vpc.default.cidr_block}"
}
output "bastion.ip" {
  value = "${aws_eip.bastion.public_ip}"
}
output "master.1.ip" {
  value = "${aws_instance.mesos-master.0.private_ip}"
}
output "master_ips" {
   value = "${join(",", aws_instance.mesos-master.*.private_ip)}"
}
output "slave-a_ips" {
   value = "${join(",", aws_instance.mesos-slave.*.private_ip)}"
}
output "slave-b_ips" {
   value = "${join(",", aws_instance.mesos-slave-b.*.private_ip)}"
}
output "elasticsearch_ips" {
   value = "${join(",", aws_instance.elasticsearch.*.private_ip)}"
}
output "elb.hostname" {
  value = "${aws_elb.app.dns_name}"
}
output "nat_ips" {
  value = "${join(",", aws_eip.nat_gateway.*.public_ip)}"
}
