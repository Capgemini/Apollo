variable "elb_name" { default = "apollo-elb" }
variable "backend_port" { default = "80"}
variable "backend_protocol" { default = "http" }
variable "health_check_target" { default = "HTTP:8888/health" }
variable "instances" {}
variable "subnets" {}
variable "security_groups" {}

resource "aws_elb" "elb" {
  name                      = "${var.elb_name}"
  cross_zone_load_balancing = true
  subnets                   = ["${split(\",\", var.subnets)}"]
  security_groups           = ["${split(\",\",var.security_groups)}"]
  instances                 = ["${split(\",\", var.instances)}"]

  listener {
    instance_port     = "${var.backend_port}"
    instance_protocol = "${var.backend_protocol}"
    lb_port           = 80
    lb_protocol       = "http"
  }

  # Traefik health check
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "${var.health_check_target}"
    interval            = 30
  }

  tags {
    Name = "${var.elb_name}"
  }
}

resource "aws_proxy_protocol_policy" "http" {
  load_balancer = "${aws_elb.elb.name}"
  instance_ports = ["80"]
}

# outputs
output "elb_id" { value = "${aws_elb.elb.id}" }
output "elb_name" { value = "${aws_elb.elb.name}" }
output "elb_dns_name" { value = "${aws_elb.elb.dns_name}" }
