## Getting started on AWS

### Prerequisites

1. You need an AWS account. Visit [http://aws.amazon.com](http://aws.amazon.com) to get started
2. You need an AWS [instance profile and role](http://docs.aws.amazon.com/IAM/latest/UserGuide/instance-profiles.html) with EC2 full access.
3. You need an Atlas account. Visit [https://atlas.hashicorp.com](https://atlas.hashicorp.com) to get started.
4. You need to have installed and configured Terraform. Visit [https://www.terraform.io/intro/getting-started/install.html](https://www.terraform.io/intro/getting-started/install.html) to get started.
5. You will need a VPN client if you want to access the web interfaces for Mesos, Consul and Marathon. We recommend using Tunnelblick. Visit [https://code.google.com/p/tunnelblick/](https://code.google.com/p/tunnelblick/) to download and install.
6. You need to have Python <= 2.7.5 installed.
7. You need to have ansible [http://www.ansible.com/home](ansible) installed.
8. You need to have [https://github.com/devo-ps/dopy](dopy) installed.

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
AWS_ACCESS_KEY
AWS_SSH_KEY
AWS_SSH_KEY_NAME
ATLAS_TOKEN
```

#### Turn up the cluster
```
sh bootstrap/apollo-launch.sh
```

NOTE: The script will provision a new VPC and a 3 node mesos master cluster in eu-west-1 (Ireland). It will also create a mesos slave cluster and a NAT server for accessing the VPC via VPN and SSH.

It will also attempt to start and configure a VPN client connection for you.

For instructions on how to configure the VPN (outside of the bootstrap script) to access the web interface of the tools see the [vpn guide](../aws/vpn.md).

#### Tearing down the cluster
```
sh bootstrap/apollo-down.sh
```
