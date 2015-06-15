output "master.1.ip" {
  value = "${azure_instance.mesos-master.0.vip_address}"
}
output "master_ips" {
   value = "${join(",", azure_instance.mesos-master.*.vip_address)}"
}
output "slave_ips" {
   value = "${join(",", azure_instance.mesos-slave.*.vip_address)}"
}
