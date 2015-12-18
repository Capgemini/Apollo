resource "aws_elb" "web" {
  name = "${var.elb_name}"

  subnets = ["${aws_subnet.public.*.id}"]

  security_groups = ["${aws_security_group.default.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:34180/haproxy_status"
    interval            = 30
  }

  instances = ["${aws_instance.mesos-slave.*.id}"]
  cross_zone_load_balancing = true
}

resource "aws_proxy_protocol_policy" "http" {
  load_balancer = "${aws_elb.web.name}"
  instance_ports = ["80"]
}
