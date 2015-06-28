/* Base packer build we use for provisioning master instances */
resource "atlas_artifact" "mesos-master" {
  name = "${ var.atlas_artifact.master }"
  type = "openstack.image"
}

/* Mesos master instances */
resource "openstack_compute_instance_v2" "mesos-master" {
  name            = "apollo-mesos-master-${count.index}"
  key_pair        = "${ var.key_name }"
  image_id        = "${ replace(atlas_artifact.mesos-master.id, concat(var.region, ":"), "") }"
  flavor_id       = "${ var.instance_type.master }"
  security_groups = ["${ openstack_compute_secgroup_v2.default.id }"]
  network         = { uuid  = "${ openstack_networking_network_v2.public.id }" }
  count           = "${ var.masters }"
  metadata        = {
    role = "mesos_masters"
  }

  connection {
    user = "ubuntu"
    key_file = "${var.key_file}"
  }  
}
