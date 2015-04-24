/* Create a new SSH key */
resource "digitalocean_ssh_key" "default" {
    name = "Apollo"
    public_key = "${file(var.key_file)}"
}

/* Mesos master instances */
resource "digitalocean_droplet" "mesos-master" {
  image              = "${var.image.master}"
  region             = "${var.region}"
  count              = "${var.masters}"
  name               = "capgemini-mesos-master-${count.index}"
  size               = "${var.instance_size.master}"
  depends_on         = ["digitalocean_ssh_key.default"]
  private_networking = true
  ssh_keys = [
	"${digitalocean_ssh_key.default.id}"
  ]
}
