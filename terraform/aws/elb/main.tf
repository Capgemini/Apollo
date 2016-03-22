variable "elb_name" { default = "apollo-elb" }
variable "backend_port" { default = "80"}
variable "backend_protocol" { default = "http" }
variable "health_check_target" { default = "HTTP:8888/health" }
variable "instances" {}
variable "subnets" {}
variable "vpc_id" {}
variable "security_groups" {}

resource "aws_s3_bucket" "elb" {
  bucket = "apollo-elb-logs"
  acl    = "private"
  policy = <<EOF
{
  "Id": "Policy1452702754917",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1452721717197",
      "Action": "s3:*",
      "Effect": "Allow",
      "Principal": "*",
      "Resource": "arn:aws:s3:::apollo-elb-logs/*",
      "Condition": {
        "StringEquals": {
          "aws:sourceVpc": "${var.vpc_id}"
        }
      }
    },
    {
      "Sid": "Stmt1452702704115",
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::apollo-elb-logs/elb/AWSLogs/*",
      "Principal": {
        "AWS": [
          "156460612806"
        ]
      }
    }
  ]
}
EOF

  tags {
    Name = "${var.elb_name}"
  }
}

resource "aws_elb" "elb" {
  name                      = "${var.elb_name}"
  cross_zone_load_balancing = true
  subnets                   = ["${split(\",\", var.subnets)}"]
  security_groups           = ["${split(\",\",var.security_groups)}"]
  instances                 = ["${split(\",\", var.instances)}"]
  depends_on                = ["aws_s3_bucket.elb"]

  listener {
    instance_port     = "${var.backend_port}"
    instance_protocol = "${var.backend_protocol}"
    lb_port           = 80
    lb_protocol       = "http"
  }

  access_logs {
    bucket        = "${aws_s3_bucket.elb.id}"
    bucket_prefix = "elb"
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
output "elb_s3" { value = "${aws_s3_bucket.elb.id}" }
