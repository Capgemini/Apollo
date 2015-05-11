/* Create a new SSH key */
resource "digitalocean_ssh_key" "default" {
    name = "Apollo"
    public_key = "${file(var.key_file)}"
}

/* Base packer build we use for provisioning master instances */
resource "atlas_artifact" "mesos-master" {
  name    = "${var.atlas_artifact.master}"
  type    = "digitalocean.image"
  version = "${var.atlas_artifact_version.master}"
}

/* Mesos master instances */
resource "digitalocean_droplet" "mesos-master" {
  image              = "${atlas_artifact.mesos-master.id}"
  region             = "${var.region}"
  count              = "${var.masters}"
  name               = "apollo-mesos-master-${count.index}"
  size               = "${var.instance_size.master}"
  depends_on         = ["digitalocean_ssh_key.default"]
  private_networking = true
  ssh_keys = [
    "${digitalocean_ssh_key.default.id}"
  ]
}
