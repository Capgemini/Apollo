#### Variable definitions ####

# Provider / global variables.
variable "region"    { default = "LON" } # Openstack region.
variable "tenant_name" {} # Openstack tennant ID.
variable "user_name"  {} # Openstack account username.
variable "password"  {} # Openstack account password.
variable "auth_url"  { default = "https://identity.api.rackspacecloud.com/v2.0"} # Openstack API url. Defaults to Rackspace's APIs

# Image ids
variable "coreos_stable_image" { default = "40155f16-21d4-4ac1-ad65-c409d94b8c7c" } # Defaults to Rackspcace CoreOS stable image id.

# ssh key variables
variable "key_name"        { default = "apollo" } # The name of the ssh key to associate with Openstack instances.
variable "public_key_file" { default = "~/.ssh/id_rsa_rs.pub" } # The path to the public ssh key.

#  Networking variables
## Private networks cannot be created in Rackspace via Terraform at the moment, due to a Gophercloud bug and slight differences between Openstack and Rackspace's implementation of it.
## See https://github.com/hashicorp/terraform/issues/1560 for more info.
variable "public_network_id"    { default = "00000000-0000-0000-0000-000000000000" } # Default id for the Rackspace public network
variable "public_network_name"  { default = "PublicNet"} # Default name for the Rackspace public network

# Mesos variables
variable "mesos_masters"              { default = "3" }
variable "mesos_master_instance_type" { default = "general1-4" }
variable "mesos_slaves"               { default = "1" }
variable "mesos_slave_instance_type"  { default = "general1-4" }

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
module "etcd-discovery" {
  source                  = "./modules/etcd_discovery"
  mesos_masters           = "${var.mesos_masters}"
  mesos_slaves            = "${var.mesos_slaves}"
  etcd_discovery_url_file = "${var.etcd_discovery_url_file}"
}

# resource "null_resource" "etcd_discovery" {
#   # Changes to the specified variables will trigger the provisioner again
#   triggers {
#     mesos_masters = "${var.mesos_masters}"
#     mesos_slaves  = "${var.mesos_slaves}"
#   }

#   provisioner "local-exec" {
#     command = "curl https://discovery.etcd.io/new?size=${var.mesos_masters + var.mesos_slaves} > ${var.etcd_discovery_url_file}"
#   }
# }

# Mesos Masters
module "mesos-masters" {
  source                  = "./modules/mesos_masters"
  region                  = "${var.region}"
  instance_type           = "${var.mesos_master_instance_type}"
  image_id                = "${var.coreos_stable_image}"
  key_pair                = "${var.key_name}"
  network_id              = "${var.public_network_id}"
  network_name            = "${var.public_network_name}"
  etcd_discovery_url_file = "${var.etcd_discovery_url_file}"
  masters                 = "${var.mesos_masters}"
  slaves                  = "${var.mesos_slaves}"
  etcd_discovery_ready    = "${module.etcd-discovery.executed_check}" # Make sure that the etc_discovery_url file has been populated
}

# Mesos Slaves
module "mesos-slaves" {
  source                  = "./modules/mesos_slaves"
  region                  = "${var.region}"
  instance_type           = "${var.mesos_slave_instance_type}"
  image_id                = "${var.coreos_stable_image}"
  key_pair                = "${var.key_name}"
  network_id              = "${var.public_network_id}"
  network_name            = "${var.public_network_name}"
  etcd_discovery_url_file = "${var.etcd_discovery_url_file}"
  masters                 = "${var.mesos_masters}"
  slaves                  = "${var.mesos_slaves}"
  etcd_discovery_ready    = "${module.etcd-discovery.executed_check}" # Make sure that the etc_discovery_url file has been populated
}

#######################################################################################################


#### Outputs ####

output "master_ips" {
  value = "${module.mesos-masters.master_ips}"
}
output "slave_ips" {
  value = "${module.mesos-slaves.slave_ips}"
}
