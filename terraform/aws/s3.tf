resource "aws_vpc_endpoint" "private-s3" {
  vpc_id = "${aws_vpc.default.id}"
  service_name = "com.amazonaws.${var.region}.s3"
  route_table_ids = ["${aws_route_table.private.*.id}"]
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*",
      "Principal": "*",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "state" {
  bucket = "udacity-${var.cluster_name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "Policy1234567890123",
  "Statement": [
    {
      "Sid": "Stmt1234567890123",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::udacity-${var.cluster_name}/*",
      "Condition": {
        "StringEquals": { "aws:sourceVpc": "${aws_vpc.default.id}" }
      }
    },
    {
      "Sid": "AWSConsoleStmt-1451318164342",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::027434742980:root",
          "arn:aws:iam::035351147821:root",
          "arn:aws:iam::903692715234:root",
          "arn:aws:iam::127311923021:root",
          "arn:aws:iam::216624486486:root",
          "arn:aws:iam::086441151436:root",
          "arn:aws:iam::783225319266:root",
          "arn:aws:iam::156460612806:root",
          "arn:aws:iam::797873946194:root",
          "arn:aws:iam::859597730677:root",
          "arn:aws:iam::814480443879:root",
          "arn:aws:iam::114774131450:root",
          "arn:aws:iam::582318560864:root",
          "arn:aws:iam::507241528517:root",
          "arn:aws:iam::388731089494:root",
          "arn:aws:iam::054676820928:root",
          "arn:aws:iam::113285607260:root",
          "arn:aws:iam::284668455005:root"
        ]
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::udacity-${var.cluster_name}/AWSLogs/*"
    }
  ]
}
EOF

  tags {
    Name = "State Bucket"
    Cluster = "${var.cluster_name}"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_object" "logstash_config" {
  bucket = "${aws_s3_bucket.state.id}"
  key = "etc/logstash.conf"
  source = "s3/etc_logstash.conf"
}
