output "master.1.ip" {
  value = "${google_compute_instance.mesos-master.0.network_interface.0.access_config.0.nat_ip}"
}
output "master.2.ip" {
  value = "${google_compute_instance.mesos-master.1.network_interface.0.access_config.0.nat_ip}"
}
output "master.3.ip" {
  value = "${google_compute_instance.mesos-master.2.network_interface.0.access_config.0.nat_ip}"
}
output "master_ips" {
   value = "${join(",", google_compute_instance.mesos-master.*.network_interface.0.access_config.0.nat_ip)}"
}
output "slave_ips" {
   value = "${join(",", google_compute_instance.mesos-slave.*.network_interface.0.access_config.0.nat_ip)}"
}
