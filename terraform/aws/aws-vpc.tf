provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

/* Define our vpc */
resource "aws_vpc" "default" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

/* VPC Flow Logs Role and Policy */
resource "aws_iam_role" "vpc_flow_logs" {
  name = "vpc-flow-logs"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch_logs" {
  name = "cloudwatch-logs"
  role = "${aws_iam_role.vpc_flow_logs.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

/* Cloudwatch Log Group */
resource "aws_cloudwatch_log_group" "vpc" {
  name = "${var.cloudwatch_vpc_flow_log_group}" 
}

/* VPC Flow Logs */
resource "aws_flow_log" "vpc-flow-logs" {
  log_group_name = "${aws_cloudwatch_log_group.vpc.name}"
  iam_role_arn = "${aws_iam_role.vpc_flow_logs.arn}"
  vpc_id = "${aws_vpc.default.id}"
  traffic_type = "ALL"
}

