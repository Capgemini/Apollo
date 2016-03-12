variable "security_group_name" { default = "default" }

resource "openstack_compute_secgroup_v2" "default" {
  name = "${var.security_group_name}"
  description = "Default security group allowing all traffic"
  # Allows inbound and outbound traffic from all instances within this group. 
  # Not quite necessary at the moment as the next rule allows all ingress and egress traffic.
  rule {
    from_port   = 0
    to_port     = 0
    ip_protocol = "-1"
    self        = true
  }
  # Allows inbound and outbound traffic.
  rule {
    from_port   = 0
    to_port     = 0
    ip_protocol = "-1"
    cidr        = "0.0.0.0/0"
  }
}

# Outputs
output "security_group_name" {
  value = "${openstack_compute_secgroup_v2.default.name}"
}
