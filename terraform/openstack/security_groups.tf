# /* Default security group */
# resource "openstack_compute_secgroup_v2" "default" {
#   name        = "default-apollo-mesos"
#   description = "Default security group that allows all traffic"

#   # Allows inbound and outbound traffic from all instances 
#   rule {
#     from_port   = "0"
#     to_port     = "0"
#     ip_protocol = "-1"
#     self        = true
#   }

#   # Allows all inbound traffic from the internet.
#   rule {
#     from_port   = "0"
#     to_port     = "0"
#     ip_protocol = "-1"
#     cidr        = "0.0.0.0/0"
#   }
# }
