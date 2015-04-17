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
  provisioner "remote-exec" {
    inline = [
      "echo ${digitalocean_droplet.mesos-slave.ipv4_address} | sudo tee /etc/mesos-slave/hostname",
      "echo auto weave >> /etc/network/interfaces.d/weave.cfg",
      "echo iface weave inet manual >> /etc/network/interfaces.d/weave.cfg",
      "echo pre-up /usr/local/bin/weave create-bridge >> /etc/network/interfaces.d/weave.cfg",
      "echo post-up ip addr add dev weave 10.2.0.${count.index+1}/16 >> /etc/network/interfaces.d/weave.cfg",
      "echo pre-down ifconfig weave down >> /etc/network/interfaces.d/weave.cfg",
      "echo post-down brctl delbr weave >> /etc/network/interfaces.d/weave.cfg",
      "echo \"DOCKER_OPTS=\"--bridge=weave --fixed-cidr=10.2.${count.index+1}.0/24\"\" | sudo tee -a /etc/default/DOCKER_OPTS"
    ]
  }
  /* Upload the master IP addresses so we can configure them from the slave machine */
  provisioner "file" {
    source = "public_ips.txt"
    destination = "/tmp/masters"
  }
  provisioner "file" {
    source      = "${var.key_file}"
    destination = "/root/.ssh/id_rsa"
  }
  /*provisioner "remote-exec" {

  }*/
}
