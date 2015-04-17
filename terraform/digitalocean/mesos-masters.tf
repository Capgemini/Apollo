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
  connection {
    user     = "root"
    type     = "ssh"
    key_file = "${var.key_file}"
    timeout  = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "echo ${digitalocean_droplet.mesos-master.ipv4_address} | sudo tee /etc/mesos-master/hostname",
      "echo 2 | sudo tee /etc/mesos-master/quorum",
      "echo ${count.index+1} | sudo tee /etc/zookeeper/conf/myid",
      "echo server.${count.index+1}=${digitalocean_droplet.mesos-master.ipv4_address}:2888:3888 | sudo tee -a /etc/zookeeper/conf/zoo.cfg",
    ]
  }
  provisioner "local-exec" {
    command = "echo ${digitalocean_droplet.mesos-master.ipv4_address} >> public_ips.txt"
  }
}
