provider "openstack" {
    user_name   = "${var.username}"
    tenant_name = "${var.tenant_id}"
    auth_url    = "${var.auth_url}"
    password    = "${var.password}
}

resource "openstack_compute_keypair_v2" "keypair" {
  name = "${ var.key_name }"
  public_key = "${ file(var.key_file) }"
}