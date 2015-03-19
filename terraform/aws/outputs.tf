output "nat.ip" {
  value = "${aws_instance.nat.public_ip}"
}
