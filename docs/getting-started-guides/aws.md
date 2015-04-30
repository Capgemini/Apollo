## Getting started on AWS

### Prerequisites

1. You need an AWS account. Visit [http://aws.amazon.com](http://aws.amazon.com) to get started
2. You need an AWS [instance profile and role](http://docs.aws.amazon.com/IAM/latest/UserGuide/instance-profiles.html) with EC2 full access.
3. You need an Atlas account. Visit [https://atlas.hashicorp.com](https://atlas.hashicorp.com) to get started.
4. You need to have installed and configured Terraform (>= 0.4.2 recommended). Visit [https://www.terraform.io/intro/getting-started/install.html](https://www.terraform.io/intro/getting-started/install.html) to get started.
5. You will need a VPN client if you want to access the web interfaces for Mesos, Consul and Marathon. We recommend using Tunnelblick. Visit [https://code.google.com/p/tunnelblick/](https://code.google.com/p/tunnelblick/) to download and install.
6. The latest version of Ansible (for provisioning) installed (>= 1.9.0) [http://docs.ansible.com/intro_installation.html](http://docs.ansible.com/intro_installation.html) to get started. Do not install 1.9.1 [https://github.com/ansible/ansible-modules-core/issues/1170](https://github.com/ansible/ansible-modules-core/issues/1170)
7. [Python](https://www.python.org/) version (>= 2.7.5) installed.
8. The Python AWS SDK [Boto](https://github.com/boto/boto) installed.
This can be installed via pip - ```pip install boto```. This is used for the Ansible dynamic inventory.

### Cluster Turnup

#### Download Apollo

##### Install from source at head
1. ```git clone https://github.com/Capgemini/apollo.git```
2. ```cd apollo```

#### Set config

Configuration can be set via environment variables. For a full list of available config
options for AWS see ```bootstrap/aws/config-default.sh```

As a minimum you will need to set these environment variables -

```
APOLLO_PROVIDER=aws
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SSH_KEY
AWS_SSH_KEY_NAME
ATLAS_TOKEN
```

#### Turn up the cluster
```
sh bootstrap/apollo-launch.sh
```

NOTE: The script will provision a new VPC and a 3 node mesos master cluster in eu-west-1 (Ireland). It will also create a mesos slave cluster and a NAT server for accessing the VPC via VPN and SSH.

It will then generate a local SSH config for the NAT server and the private instances, and run an
Ansible playbook to provision the cluster.

Finally it will attempt to start and configure a VPN client connection for you.

For instructions on how to configure the VPN (outside of the bootstrap script) to access the web interface of the tools see the [vpn guide](../aws/vpn.md).

#### Tearing down the cluster
```
sh bootstrap/apollo-down.sh
```

#### SSH'ing to your private instances

As part of ```apollo-launch.sh``` an SSH config file will be generated in ```$APOLLO_ROOT/terraform/aws/ssh.config```.

If your master instance has a private IP of 10.0.1.11 (for example), You can SSH directly to that instance by doing the following -

```
ssh -F $APOLLO_ROOT/terraform/aws/ssh.config 10.0.1.11
```

This will proxy your SSH command via the NAT server and you should land in the master private instance.
