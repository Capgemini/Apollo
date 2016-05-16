#### Variable definitions ####

# Provider / global variables.
variable "region"    { default = "LON" } # Openstack region.
variable "tenant_name" {} # Openstack tennant ID.
variable "user_name"  {} # Openstack account username.
variable "password"  {} # Openstack account password.
variable "auth_url"  { default = "https://identity.api.rackspacecloud.com/v2.0"} # Openstack API url. Defaults to Rackspace's APIs

# Image ids
variable "coreos_stable_image" { default = "40155f16-21d4-4ac1-ad65-c409d94b8c7c" } # Defaults to Rackspcace CoreOS stable image id.
variable "coreos_beta_image" {default = "6045cb80-52ed-4114-bf9a-7f15a36c65dc" } # Defaults to Rackspcace CoreOS beta image id.

# ssh key variables
variable "key_name"        { default = "apollo" } # The name of the ssh key to associate with Openstack instances.
variable "public_key_file" { default = "~/.ssh/id_rsa_rs.pub" } # The path to the public ssh key.

#  Networking variables
## Private networks cannot be created in Rackspace via Terraform at the moment, due to a Gophercloud bug and slight differences between Openstack and Rackspace's implementation of it.
## See https://github.com/hashicorp/terraform/issues/1560 for more info.
variable "public_network_id"    { default = "00000000-0000-0000-0000-000000000000" } # Default id for the Rackspace Public network
variable "public_network_name"  { default = "PublicNet"} # Default name for the Rackspace public network
## We need the eth1 adapter to be available, along with a non-public/private IP address, and this isn't possible just by attaching the resource to the PublicNet
variable "private_network_id"    { default = "11111111-1111-1111-1111-111111111111" } # Default id for the Rackspace Service network
variable "private_network_name"  { default = "ServiceNet"} # Default name for the Rackspace Service network

# Mesos variables
variable "mesos_masters"              { default = "3" }
variable "mesos_master_instance_type" { default = "general1-4" }
variable "mesos_agents"               { default = "1" }
variable "mesos_agent_instance_type"  { default = "general1-4" }

# Etcd variables
variable "etcd_discovery_url_file" { default = "etcd_discovery_url.txt"}

#######################################################################################################


#### Resources ####

# Provider
provider "openstack" {
  auth_url    = "${var.auth_url}"
  tenant_name = "${var.tenant_name}"
  user_name   = "${var.user_name}"
  password    = "${var.password}"
}

# SSH Keys
module "keypair" {
  source          = "./modules/keypair"
  key_name        = "${var.key_name}"
  public_key_file = "${var.public_key_file}"
}

# Etcd discovery
resource "template_file" "etcd_discovery" {
  template = "${file("/dev/null")}"

  provisioner "local-exec" {
    command = "curl https://discovery.etcd.io/new?size=${var.masters} > ${var.etcd_discovery_url_file}"
  }
  # This will regenerate the discovery URL if the cluster size changes
  vars {
    size = "${var.masters}"
  }
}

## Rackspace's API's expect a call to /security-groups in order to create a security group, but Terraform uses the default Openstack endpoint /os-security-groups which does not exist in Rackspace.
## Comment this in for Openstack providers that support security groups via terraform.

# # Default security group
# module "default-security-group" {
#   source              = "./modules/sg-default"
#   security_group_name = "default"
# }

# Mesos Masters
module "mesos-masters" {
  source                  = "./modules/mesos_masters"
  region                  = "${var.region}"
  instance_type           = "${var.mesos_master_instance_type}"
  image_id                = "${var.coreos_stable_image}"
  key_pair                = "${module.keypair.keypair_name}"
  public_network_id       = "${var.public_network_id}"
  public_network_name     = "${var.public_network_name}"
  private_network_id      = "${var.private_network_id}"
  private_network_name    = "${var.private_network_name}"
  # security_groups         = "${module.default-security-group.security_group_name}" # Comment this in for Openstack providers that support security groups via terraform.
  etcd_discovery_url_file = "${template_file.etcd_discovery_url}"
  masters                 = "${var.mesos_masters}"
  agents                  = "${var.mesos_agents}"
}

# Mesos Agents
module "mesos-agents" {
  source                  = "./modules/mesos_agents"
  region                  = "${var.region}"
  instance_type           = "${var.mesos_agent_instance_type}"
  image_id                = "${var.coreos_stable_image}"
  key_pair                = "${module.keypair.keypair_name}"
  public_network_id       = "${var.public_network_id}"
  public_network_name     = "${var.public_network_name}"
  private_network_id      = "${var.private_network_id}"
  private_network_name    = "${var.private_network_name}"
  # security_groups         = "${module.default-security-group.security_group_name}" # Comment this in for Openstack providers that support security groups via terraform.
  etcd_discovery_url_file = "${template_file.etcd_discovery_url}"
  masters                 = "${var.mesos_masters}"
  agents                  = "${var.mesos_agents}"
}

#######################################################################################################


#### Outputs ####

output "master_ips" {
  value = "${module.mesos-masters.master_ips}"
}
output "agent_ips" {
  value = "${module.mesos-agents.agent_ips}"
}
# We need this for the open_urls function
output "master.1.ip" {
  value = "${element(split(",", module.mesos-masters.master_ips), 0)}"
}
