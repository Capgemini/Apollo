/* Mesos slave instances */
resource "digitalocean_droplet" "mesos-slave" {
  image              = "${var.image.slave}"
  region             = "${var.region}"
  count              = "${var.slaves}"
  name               = "capgemini-mesos-slave-${count.index}"
  size               = "${var.instance_size.slave}"
  depends_on         = ["digitalocean_droplet.mesos-master"]
  private_networking = true
  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]

  connection {
    user     = "root"
    type     = "ssh"
    key_file = "${var.key_file}"
    timeout  = "2m"
  }
}
