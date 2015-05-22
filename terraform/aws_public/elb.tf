resource "aws_elb" "web" {
  name = "apollo-elb"

  availability_zones = ["${var.availability_zone}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 30
  }

  instances = ["${aws_instance.mesos-slave.*.id}"]
  cross_zone_load_balancing = true
}
