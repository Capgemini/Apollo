/* Mesos master instances */
resource "digitalocean_droplet" "load-balancer" {
  image              = "${var.image.lb}"
  region             = "${var.region}"
  count              = "1"
  name               = "apollo-load-balancer-1"
  size               = "${var.instance_size.lb}"
  depends_on         = ["digitalocean_ssh_key.default"]
  private_networking = true
  ssh_keys = [
    "${digitalocean_ssh_key.default.id}"
  ]
}
