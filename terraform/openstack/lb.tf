# resource "openstack_lb_vip_v1" "vip_1" {
#   name = "tf_test_lb_vip"
#   subnet_id = "12345"
#   protocol = "HTTP"
#   port = 80
#   pool_id = "67890"
#   tenant_id = "${var.tenant_id}"
# }

# resource "openstack_lb_pool_v1" "pool_1" {
#   name = "tf_test_lb_pool"
#   protocol = "HTTP"
#   subnet_id = "12345"
#   lb_method = "ROUND_ROBIN"
#   monitor_ids = ["67890"]
#   member {
#     address = "192.168.0.1"
#     port = 80
#     admin_state_up = "true"
#   }
#   tenant_id = "${var.tenant_id}"
# }

# resource "openstack_lb_monitor_v1" "monitor_1" {
#   type = "PING"
#   delay = 30
#   timeout = 5
#   max_retries = 3
#   admin_state_up = "true"
# }
