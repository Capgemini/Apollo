# /* Base packer build we use for provisioning master instances */
# resource "atlas_artifact" "mesos-master" {
#   name = "${var.atlas_artifact.master}"
#   type = "openstack.image"
# }

/* Mesos slave instances */
resource "openstack_compute_instance_v2" "mesos-slaves" {
  count           = "${ var.slaves }"
  name            = "apollo-mesos-slave-${count.index}"
  key_pair        = "${ var.key_name }"
  image_id        = "b9cb604d-866f-47f2-8031-8452533460d5"
  flavor_id       = "${ var.instance_type.slave }"
  # security_groups = ["${ openstack_compute_secgroup_v2.default.id }"]
  # network         = { uuid  = "${ openstack_networking_network_v2.public.id }" }
  depends_on      = ["openstack_compute_keypair_v2.default", "openstack_compute_instance_v2.mesos-master"]
  metadata        = {
    role = "mesos_slaves"
  }

  connection {
    user = "ubuntu"
    key_file = "${var.key_file}"
  }  
}
