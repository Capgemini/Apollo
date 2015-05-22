resource "aws_elb" "web" {
  name = "apollo-elb"

  subnets = ["${aws_subnet.public.id}"]

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
    target              = "HTTP:80/"
    interval            = 30
  }

  instances = ["${aws_instance.mesos-slave.*.id}"]
  cross_zone_load_balancing = true
}
