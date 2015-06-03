output "master.1.ip" {
  value = "${google_compute_instance.mesos-master.0.ipv4_address}"
}
output "master.2.ip" {
  value = "${google_compute_instance.mesos-master.1.ipv4_address}"
}
output "master.3.ip" {
  value = "${google_compute_instance.mesos-master.2.ipv4_address}"
}
output "master_ips" {
   value = "${join(",", google_compute_instance.mesos-master.*.ipv4_address)}"
}
output "slave_ips" {
   value = "${join(",", google_compute_instance.mesos-slave.*.ipv4_address)}"
}
