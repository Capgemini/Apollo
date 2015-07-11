provider "openstack" {
  user_name     = "${var.username}"
  tenant_name   = "${var.tenant_id}"
  auth_url      = "${var.auth_url}"
  # api_key       = "${var.api_key}"
  password      = "${var.password}"
  endpoint_type = "${var.endpoint_type}"
}

resource "openstack_compute_keypair_v2" "default" {
  name       = "${ var.key_name }"
  public_key = "${ file(var.key_file) }"
}
