## Getting started on AWS

### Prerequisites

1. You need an AWS account. Visit [http://aws.amazon.com](http://aws.amazon.com) to get started
2. Install and configure [AWS Command Line Interface](http://aws.amazon.com/cli)
3. You need an AWS [instance profile and role](http://docs.aws.amazon.com/IAM/latest/UserGuide/instance-profiles.html) with EC2 full access.
4. You need an Atlas account. Visit [https://atlas.hashicorp.com](https://atlas.hashicorp.com) to get started.
5. You need to have installed and configured Terraform. Visit [https://www.terraform.io/intro/getting-started/install.html](https://www.terraform.io/intro/getting-started/install.html) to get started.


### Cluster Turnup

#### Download Apollo

##### Install from source at head
1. ```git clone https://github.com/Capgemini/apollo.git```
2. ```cd apollo/terraform/aws```

#### Set config
1. ```cp terraform.tfvars.example terraform.tfvars```

Edit ```terraform.tfvars``` to include your AWS access/secret, keyfile/keyname and Atlas token.

#### Checking you have the correct config
```
terraform plan
```

This should execute a dry-run indicating what Terraform will do when it is run. This should highlight any config issues from above steps.

#### Turn up the cluster
```
terraform apply
```

NOTE: The script will provision a new VPC and a 3 node mesos master cluster in eu-west-1 (Ireland). It'll also try to create a mesos slave cluster and a NAT server for accessing via VPN and SSH.

For instructions on how to configure the VPN to access the web interface of the tools see the [vpn guide](../aws/vpn.md).
