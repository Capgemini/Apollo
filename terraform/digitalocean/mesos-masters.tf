/* Mesos master instances */
resource "digitalocean_droplet" "mesos-master" {
  image              = "${var.image.master}"
  region             = "${var.region}"
  count              = "${var.masters}"
  name               = "capgemini-mesos-master-${count.index}"
  size               = "${var.instance_size.master}"
  private_networking = true
  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]
}
