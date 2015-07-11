# /* Base packer build we use for provisioning master instances */
# resource "atlas_artifact" "mesos-master" {
#   name    = "${var.atlas_artifact.master}"
#   type    = "openstack.image"
#   version = "${var.atlas_artifact_version.master}"
# }

/* Mesos master instances */
resource "openstack_compute_instance_v2" "mesos-master" {
  count           = "${ var.masters }"
  name            = "apollo-mesos-master-${count.index}"
  key_pair        = "${ var.key_name }"
  image_id        = "b9cb604d-866f-47f2-8031-8452533460d5"
  flavor_id       = "${ var.instance_type.master }"
  # security_groups = ["${ openstack_compute_secgroup_v2.default.id }"]
  # network         = { uuid  = "${ openstack_networking_network_v2.public.id }" }
  depends_on      = ["openstack_compute_keypair_v2.default"]
  metadata        = {
    role = "mesos_masters"
  }

  connection {
    user = "ubuntu"
    key_file = "${var.key_file}"
  }  
}
