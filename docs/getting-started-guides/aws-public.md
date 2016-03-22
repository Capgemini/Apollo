## Getting started on AWS

### Prerequisites

1. You need an AWS account. Visit [http://aws.amazon.com](http://aws.amazon.com) to get started
2. You need an AWS [instance profile and role](http://docs.aws.amazon.com/IAM/latest/UserGuide/instance-profiles.html) with EC2 full access.
4. You need to have installed and configured Terraform (>= 0.6.10 recommended). Visit [https://www.terraform.io/intro/getting-started/install.html](https://www.terraform.io/intro/getting-started/install.html) to get started.
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

For a full list of default config options for AWS see `bootstrap/aws-public/config-default.sh`

As a minimum you will need to set these environment variables -

```
APOLLO_PROVIDER=aws-public
TF_VAR_access_key
TF_VAR_secret_key
TF_VAR_key_name="deployer"
TF_VAR_key_file='~/.ssh/id_rsa_aws.pub'
```

#### Turn up the cluster
```
/bin/bash bootstrap/apollo-launch.sh
```

NOTE: The script will provision a new VPC and a 3 node mesos master cluster across all the availability zones in eu-west-1 (Ireland).

#### Tearing down the cluster
```
/bin/bash bootstrap/apollo-down.sh
```


