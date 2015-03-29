output "nat.ip" {
  value = "${aws_instance.nat.public_ip}"
}

output "loadbalancer.ip" {
  value = "${aws_instance.loadbalancer.public_ip}"
}
