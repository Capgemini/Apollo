# /* Public subnet */
# resource "openstack_networking_network_v2" "public" {
#   admin_state_up = "true"
#   tenant_id      = "${var.tenant_id}"
# }

# resource "openstack_networking_subnet_v2" "public" {
#   network_id = "${ openstack_networking_network_v2.public.id }"
#   cidr = "${ var.public_subnet_cidr_block }"
#   ip_version = 4
# }

# resource "openstack_networking_router_v2" "public" {
#   admin_state_up = "true"
#   external_gateway = "${ var.network_id }"
#   tenant_id      = "${var.tenant_id}"
# }

# resource "openstack_networking_router_interface_v2" "public" {
#   router_id = "${ openstack_networking_router_v2.public.id }"
#   subnet_id = "${ openstack_networking_subnet_v2.public.id }"
# }

# resource "openstack_networking_floatingip_v2" "public" {
#   pool = "public"
# }
