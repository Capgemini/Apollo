/* Base packer build we use for provisioning master instances */
resource "atlas_artifact" "mesos-slave" {
  name    = "${var.atlas_artifact.slave}"
  type    = "digitalocean.image"
  version = "${var.atlas_artifact_version.slave}"
}

/* Mesos slave instances */
resource "digitalocean_droplet" "mesos-slave" {
  image              = "${atlas_artifact.mesos-slave.id}"
  region             = "${var.region}"
  count              = "${var.slaves}"
  name               = "apollo-mesos-slave-${count.index}"
  size               = "${var.instance_size.slave}"
  depends_on         = ["digitalocean_droplet.mesos-master"]
  private_networking = true
  ssh_keys = [
    "${digitalocean_ssh_key.default.id}"
  ]
}
