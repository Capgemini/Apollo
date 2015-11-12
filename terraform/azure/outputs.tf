output "vn_cidr_block.ip" {
  value = "${azure_virtual_network.virtual-network.address_space.0}"
}
/* bastion address */
output "bastion.ip" {
  value = "${azure_instance.bastion.vip_address}"
}
/* Private addresseses */
output "master.1.ip" {
  value = "${azure_instance.mesos-master.0.ip_address}"
}
output "master_ips" {
  value = "${join(",", azure_instance.mesos-master.*.ip_address)}"
}
output "slave_ips" {
  value = "${join(",", azure_instance.mesos-slave.*.ip_address)}"
}
