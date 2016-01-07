module "slave_amitype" {
  source        = "github.com/terraform-community-modules/tf_aws_virttype"
  instance_type = "${var.slave_instance_type}"
}

module "slave_ami" {
  source   = "github.com/terraform-community-modules/tf_aws_coreos_ami"
  region   = "${var.region}"
  channel  = "${var.coreos_channel}"
  virttype = "${module.slave_amitype.prefer_hvm}"
}

resource "template_file" "slave_cloud_init" {
  filename   = "cloud-config.yml.tpl"
  depends_on = ["template_file.etcd_discovery_url"]
  vars {
    etcd_discovery_url = "${file(var.etcd_discovery_url_file)}"
    size               = "${var.masters + var.slaves}"
  }
}

resource "aws_instance" "mesos-slave" {
  instance_type     = "${var.slave_instance_type}"
  ami               = "${module.slave_ami.ami_id}"
  count             = "${var.slaves}"
  key_name          = "${aws_key_pair.deployer.key_name}"
  source_dest_check = false
  subnet_id         = "${element(aws_subnet.private.*.id, count.index)}"
  security_groups   = ["${aws_security_group.default.id}"]
  depends_on        = ["aws_instance.bastion", "aws_internet_gateway.public", "aws_instance.mesos-master"]
  user_data         = "${template_file.master_cloud_init.rendered}"
  tags = {
    Name = "apollo-mesos-slave-${count.index}"
    role = "mesos_slaves"
  }
}

# Load balancer
resource "aws_elb" "app" {
  name            = "apollo-mesos-elb"
  subnets         = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.web.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  # traefik health check
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8888/health"
    interval            = 30
  }

  instances                 = ["${aws_instance.mesos-slave.*.id}"]
  cross_zone_load_balancing = true
}

resource "aws_proxy_protocol_policy" "http" {
  load_balancer  = "${aws_elb.app.name}"
  instance_ports = ["80"]
}
