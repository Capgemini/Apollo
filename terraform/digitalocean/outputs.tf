output "master.1.ip" {
  value = "${digitalocean_droplet.mesos-master.0.ipv4_address}"
}
output "slave.1.ip" {
  value = "${digitalocean_droplet.mesos-slave.0.ipv4_address}"
}

/*output "master.2.ip" {
  value = "${digitalocean_droplet.mesos-master.1.ipv4_address}"
}
output "master.3.ip" {
  value = "${digitalocean_droplet.mesos-master.2.ipv4_address}"
}*/
