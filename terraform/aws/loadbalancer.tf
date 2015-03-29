/* Loabalancer server */
resource "atlas_artifact" "loadbalancer" {
  name = "${var.atlas_artifact.loadbalancer}"
  type = "aws.ami"
}

resource "aws_instance" "loadbalancer" {
  instance_type     = "${var.instance_type.loadbalancer}"
  ami               = "${atlas_artifact.loadbalancer.metadata_full.region-eu-west-1}"
  count             = "${var.loadbalancer}"
  subnet_id         = "${aws_subnet.public.id}"
  security_groups   = ["${aws_security_group.default.id}", "${aws_security_group.loadbalancer.id}"]
  depends_on        = ["aws_internet_gateway.public"]
  key_name          = "${var.key_name}"
  source_dest_check = false
  tags = {
    Name = "capgemini-mesos-loadbalancer"
  }
  connection {
    user       = "ubuntu"
    key_file   = "${var.key_file}"
    host        = "${aws_instance.loadbalancer.public_ip}"
    script_path = "/tmp/${element(aws_instance.loadbalancer.*.id, count.index)}.sh"
  }
  provisioner "file" {
    source      = "${path.module}/scripts/common.sh"
    destination = "/tmp/${element(aws_instance.loadbalancer.*.id, count.index)}-00common.sh"
  }
  provisioner "file" {
    source      = "${path.module}/scripts/setup-loadbalancer.sh"
    destination = "/tmp/${element(aws_instance.loadbalancer.*.id, count.index)}-01setup-loadbalancer.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "echo main ${element(aws_instance.loadbalancer.*.private_ip, count.index)} ${element(aws_instance.loadbalancer.*.private_dns, count.index)} ${var.atlas_token} ${var.atlas_infrastructure} | cat /tmp/${element(aws_instance.loadbalancer.*.id, count.index)}-*.sh - | bash"
    ]
  }
}

resource "aws_eip" "loadbalancer" {
  instance = "${aws_instance.loadbalancer.id}"
  vpc = true
}
