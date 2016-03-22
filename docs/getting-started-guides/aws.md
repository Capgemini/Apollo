## Getting started on AWS

### Prerequisites

1. You need an AWS account. Visit [http://aws.amazon.com](http://aws.amazon.com) to get started
2. You need an AWS [instance profile and role](http://docs.aws.amazon.com/IAM/latest/UserGuide/instance-profiles.html) with EC2 full access.
4. You need to have installed and configured Terraform (>= 0.6.10 recommended). Visit [https://www.terraform.io/intro/getting-started/install.html](https://www.terraform.io/intro/getting-started/install.html) to get started.
5. You will need a VPN client if you want to access the web interfaces for Mesos, Consul and Marathon. We recommend using Tunnelblick. Visit [https://code.google.com/p/tunnelblick/](https://code.google.com/p/tunnelblick/) to download and install.
6. You need to have [Python](https://www.python.org/) >= 2.7.5 installed along with [pip](https://pip.pypa.io/en/latest/installing.html).
7. You will need to have created an SSH RSA key pair for accessing your aws intances. You can create it as follows:

```
cd ~/.ssh
ssh-keygen -P "" -t rsa -f id_rsa_aws -b 4096 -C "email@example.com"
openssl rsa -in ~/.ssh/id_rsa_aws -outform pem > id_rsa_aws.pem
chmod 400 id_rsa_aws.pem
eval `ssh-agent -s`
ssh-add id_rsa_aws.pem
```

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

For a full list of default config options for AWS see `bootstrap/aws/config-default.sh`

As a minimum you will need to set these environment variables -

```
APOLLO_PROVIDER=aws
TF_VAR_user
TF_VAR_access_key
TF_VAR_secret_key
TF_VAR_key_name="deployer"
TF_VAR_key_file='~/.ssh/id_rsa_aws.pub'
TF_VAR_private_key_file='~/.ssh/id_rsa_aws.pem'
```

#### Turn up the cluster
```
/bin/bash bootstrap/apollo-launch.sh
```

NOTE: The script will provision a new VPC and a 3 node mesos master cluster across all the availability zones in eu-west-1 (Ireland).

It will also create a mesos slave cluster and a Bastion server for accessing the VPC via VPN and SSH.

It will then generate a local SSH config for the Bastion server and the private instances, and run an
Ansible playbook to provision the cluster.

Finally it will attempt to start and configure a VPN client connection for you.

For instructions on how to configure the VPN (outside of the bootstrap script) to access the web interface of the tools see the [vpn guide](aws/vpn.md).

#### Tearing down the cluster
```
/bin/bash bootstrap/apollo-down.sh
```

#### SSH'ing to your private instances

As part of `apollo-launch.sh` an SSH config file will be generated in `$APOLLO_ROOT/terraform/aws/ssh.config`.

If your master instance has a private IP of 10.0.1.11 (for example), You can SSH directly to that instance by doing the following -

```
ssh -F $APOLLO_ROOT/terraform/aws/ssh.config 10.0.1.11
```

This will proxy your SSH command via the Bastion server and you should land in the master private instance.
