output "nat.ip" {
  value = "${aws_eip.nat.public_ip}"
}

output "loadbalancer.ip" {
  value = "${aws_eip.loadbalancer.public_ip}"
}
