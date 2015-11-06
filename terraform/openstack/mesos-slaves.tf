# /* Base packer build we use for provisioning master instances */
# resource "atlas_artifact" "mesos-master" {
#   name = "${var.atlas_artifact.master}"
#   type = "openstack.image"
# }

/* Mesos slave instances */
resource "openstack_compute_instance_v2" "mesos-slave" {
  count           = "${var.slaves}"
  name            = "apollo-mesos-slave-${count.index}"
  key_pair        = "${openstack_compute_keypair_v2.default.name}"
  image_id        = "6795a4e5-6aa1-4899-a683-4419499219c8"
  flavor_id       = "${var.instance_type.slave}"
  security_groups = ["${openstack_compute_secgroup_v2.default.id}"]
  depends_on      = ["openstack_compute_keypair_v2.default", "openstack_compute_instance_v2.mesos-master"]
  network {
    uuid  = "${openstack_networking_network_v2.public.id }"
  }
  metadata {
    role = "mesos_slaves"
  }

  connection {
    user = "root"
    key_file = "${var.key_file}"
  }
}
