output "master.1.ip" {
  value = "${openstack_compute_instance_v2.mesos-master.0.public_ip}"
}
output "master_ips" {
   value = "${join(",", openstack_compute_instance_v2.mesos-master.*.public_ip)}"
}
