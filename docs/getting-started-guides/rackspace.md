## Getting started on Rackspace 

This page provides details on how to use the Rackspace provider for Apollo. Please note that this implementation has been tested on Rackspace's implementation of Openstack. Some Openstack features (mainly related to networking and security resource provisioning) available by Terraform are NOT working in Rackspace, due to certain small differences in the Rackspace implementation of Openstack, as well as an existing Gophercloud bug. For more details, please visit [https://github.com/hashicorp/terraform/issues/1560](https://github.com/hashicorp/terraform/issues/1560)

### Prerequisites

To test the provider on Rackspace, please do the following:

1. You need a Rackspace public cloud account. Visit [https://cart.rackspace.com/en-gb/cloud](https://cart.rackspace.com/en-gb/cloud) to get started
2. After you create your account, take note of your tenant name/id. You can find it as an 8-digit number in the URL you use to access the Rackspace console.
3. You need to have installed and configured Terraform (>= 0.6.10 recommended). Visit [https://www.terraform.io/intro/getting-started/install.html](https://www.terraform.io/intro/getting-started/install.html) to get started.

_NOTE: At the moment, it is highly recommended that you use Terraform 0.6.10 (and not 0.6.11 or 0.6.12), due to a bug introduced in the Openstack provider (affecting Rackspace) in v0.6.11 which prevents Terraform from returning the access IPs for the intances it creates. Visit [https://github.com/hashicorp/terraform/issues/5358](https://github.com/hashicorp/terraform/issues/5358) for more info on this. This should be fixed in v0.6.13

4. You need to have [Python](https://www.python.org/) >= 2.7.5 installed along with [pip](https://pip.pypa.io/en/latest/installing.html).
5. You will need to have created an SSH RSA key pair for accessing your intances. You can create it as follows:

```
cd ~/.ssh
ssh-keygen -P "" -t rsa -f id_rsa_rs -b 4096 -C "email@example.com"
openssl rsa -in ~/.ssh/id_rsa_rs -outform pem > id_rsa_rs.pem
chmod 400 id_rsa_rs.pem
eval `ssh-agent -s`
ssh-add id_rsa_rs.pem
```

_NOTE: The addition of keys to the ssh agent is transient and lasts so long as the agent is running, i.e. if you reboot you will need to add the key to the agent again. To check that the key is available for the agent to use before you bootsrap Apollo, you can run 'ssh-add -l'.

### Cluster Turnup

#### Download Apollo

##### Install from source at head
1. `git clone https://github.com/Capgemini/apollo.git`
2. `cd apollo`
3. `pip install -r requirements.txt`

#### Set config

Configuration can be set via environment variables.

All variables following the pattern "TF_VAR_" will be available for Apollo in terraform, see [https://github.com/hashicorp/terraform/pull/1621#issuecomment-100825568](https://github.com/hashicorp/terraform/pull/1621#issuecomment-100825568)

All variables following pattern "APOLLO_" will be available for Apollo in ansible.

Certain default config options for Rackspace can be found in `bootstrap/rackspace/config-default.sh`

As a minimum you will need to set these environment variables, as they are initially unset in Terraform (using the defaults for the rest should work out of the box for Rackspace / London region) -

```
APOLLO_PROVIDER=rackspace
TF_VAR_user_name   (your Rackspace account username)
TF_VAR_password    (your Rackspace account password)
TF_VAR_tenant_name (your Rackspace tenant name/id, as described in step 2 in the Prerequisites section)
```

An exhaustive list of variables for further customisation of Terraform is provided below (values shown are the current defaults):

```
TF_VAR_region="LON" (the Rackspace region for your account)
TF_VAR_auth_url="https://identity.api.rackspacecloud.com/v2.0" (the Rackspace base auth API URL)
TF_VAR_coreos_stable_image="40155f16-21d4-4ac1-ad65-c409d94b8c7c" (a CoreOS stable image id)
TF_VAR_key_name="apollo" (or another name of your choice for the ssh key assigned to the Rackspace instances)
TF_VAR_public_key_file="~/.ssh/id_rsa_rs.pub" (the public ssh key to be uploaded to your Rackspace account and associated with your instances)
TF_VAR_mesos_masters="3" (The number of Mesos Master nodes)
TF_VAR_mesos_master_instance_type="general1-4" (The flavour of the Mesos Master instances)
TF_VAR_mesos_slaves="1" (The number of Mesos Slave nodes)
TF_VAR_mesos_slave_instance_type="general1-4" (The flavour of the Mesos Slave instances)
TF_VAR_etcd_discovery_url_file="etcd_discovery_url.txt" (The name of the temp file which captures the discovery URL for the CoreOS etcd2 cloud config)
```

_NOTE: As mentioned at the beginning of this document, networking resources in Rackspace cannot be created via Terraform at the moment. For this reason, resources in the current Terraform implementation are attached by default to the Rackspace public network (PublicNet) and service network (ServiceNet) (the latter is used so that a non-public/private IP address is also assigned to our resources and that the eth1 adapter is available, though technically it is far from being a private network). If you want to attach the resources in a different private network in Rackspace, you will first need to create one in the Rackspace console and reference the ID and Name of that network through the corresponding terraform variables (i.e. replace the values for the private net). The related variables along with their default values at the moment are:

```
TF_VAR_public_network_id="00000000-0000-0000-0000-000000000000"
TF_VAR_public_network_name="PublicNet"
TF_VAR_private_network_id="11111111-1111-1111-1111-111111111111"
TF_VAR_private_network_name="ServiceNet"
```

_NOTE: For non-Rackspace Openstack implemenations, networking resources can be created dynamically through Terraform and assigned to compute resources (not currently implemented). In addition, please note that Rackspace's API's expect a call to /security-groups in order to create a security group, but Terraform uses the default Openstack endpoint /os-security-groups which does not exist in Rackspace. Currently there is a module in the rackspace provider that creates a default security group (allowing all traffic), but this cannot be used with Rackspace due to the above issue and the implementation has been commented out both in the main tf file, as well as the references in the mesos compute resources within the related modules.


#### Turn up the cluster
```
/bin/bash bootstrap/apollo-launch.sh
```

_NOTE: The script will provision a new environment (in Rackspace public cloud by default) and a 3 node mesos master cluster across all the availability zones in LON (London datacenter).

It will also create a mesos slave cluster.

It will then generate a dynamic Ansible inventory based on the Terraform state file and run an Ansible playbook to provision the cluster.

After the provisioning part is completed you can open the Consul, Marathon and Mesos UIs by running:

```
/bin/bash bootstrap/apollo-launch.sh open_urls
```

#### Tearing down the cluster
```
/bin/bash bootstrap/apollo-down.sh
```
