## Getting started on Microsoft Azure

### Prerequisites

1. You need an Microsoft Azure account. Visit [http://azure.microsoft.com](http://azure.microsoft.com) to get started.
2. Unfortunately the latest version of terraform doesn't fully support azure so you need to compile terraform from the master branch to get it working. Visit [https://github.com/hashicorp/terraform](https://github.com/hashicorp/terraform) to get more instruction how to do it.
3. You need to have [Python](https://www.python.org/) >= 2.7.5 installed along with [pip](https://pip.pypa.io/en/latest/installing.html).
4. You need to install Azure CLI on your machine, you can find instructions how to do it [here](https://azure.microsoft.com/en-gb/documentation/articles/xplat-cli-install/). To find out more how to connect Azure subscription
from the Azure CLI you can find it [here](https://azure.microsoft.com/en-gb/documentation/articles/xplat-cli-connect/)
Download settings file
[https://manage.windowsazure.com/publishsettings](https://manage.windowsazure.com/publishsettings)
and perform the command:

```
azure account import path_to_your_publishsettings_file
```

Create an Azure Compatible Keys [more details you can find here](https://azure.microsoft.com/en-gb/documentation/articles/virtual-machines-linux-use-ssh-key/)

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ~/.ssh/id_rsa_azure.key -out ~/.ssh/id_rsa_azure.pem -subj '/CN=www.capgemini.com/O=Apollo./C=UK'

openssl x509 -outform der -in ~/.ssh/id_rsa_azure.pem -out ~/.ssh/id_rsa_azure.pfx

ssh-add id_rsa_azure.key
```

Upload SSH cert [https://manage.windowsazure.com/#Workspaces/AdminTasks/ListManagementCertificates](https://manage.windowsazure.com/#Workspaces/AdminTasks/ListManagementCertificates)

Create a storage account [https://manage.windowsazure.com/#Workspaces/StorageExtension](https://manage.windowsazure.com/#Workspaces/StorageExtension). I named it capgeminiapollo

Create a storage container [https://manage.windowsazure.com/#Workspaces/StorageExtension/StorageAccount/capgeminiapollo/Containers](https://manage.windowsazure.com/#Workspaces/StorageExtension/StorageAccount/capgeminiapollo/Containers)

Use the storage account name from above here and named the storage container 'images'.

### Cluster Turnup

#### Download Apollo

##### Install from source at head
1. `git clone https://github.com/Capgemini/apollo.git`
2. `cd apollo`
3. `pip install -r requirements.txt`

#### Set config

Configuration can be set via environment variables.

All variables following the pattern "TF_VAR_" will be available for Apollo in terraform, see [https://github.com/hashicorp/terraform/pull/1621#issuecomment-100825568](https://github.com/hashicorp/terraform/pull/1621#issuecomment-100825568)

All variables following pattern "APOLLO_" will be available for Apollo in ansible.

For a full list of default config options for AWS see `bootstrap/azure/config-default.sh`

As a minimum you will need to set these environment variables -

```
export APOLLO_PROVIDER=azure
export TF_VAR_user=$USER
export TF_VAR_azure_settings_file='path_to_your_azure_setting_file'
export TF_VAR_username='ubuntu'
export ATLAS_TOKEN=your_atlas_token
export TF_VAR_ssh_key_thumbprint=~/.ssh/id_rsa_azure.pem
export TF_VAR_private_key_file=~/.ssh/id_rsa_azure.key
```

_NOTE: The value for ATLAS_TOKEN should be set to whatever you generated with your [Atlas Account](https://atlas.hashicorp.com/settings/tokens).

#### Turn up the cluster
```
/bin/bash bootstrap/apollo-launch.sh
```

NOTE: The script will provision a new VPC and a 3 node mesos master cluster for North Europe region.

It will also create a mesos slave cluster and a Bastion server for accessing the VPC via VPN and SSH.

It will then generate a local SSH config for the Bastion server and the private instances, and run an Ansible playbook to provision the cluster.

Finally it will attempt to start and configure a VPN client connection for you.

For instructions on how to configure the VPN (outside of the bootstrap script) to access the web interface of the tools see the [vpn guide](https://github.com/ravbaba/Apollo/blob/azure-provider/docs/getting-started-guides/aws/vpn.md).

#### Tearing down the cluster
```
/bin/bash bootstrap/apollo-down.sh
```

### Packer build

Follow the instructions [here](https://github.com/msopentech/packer-azure) to build the compile the packer plugin for Azure via Go and copy it to your packer install folder (normally
/usr/local/packer/) and set those variables:

```
export AZURE_SETTINGS_FILE=path_to_your_azure_publishsettings_file
export AZURE_SUBSCRIPTION_NAME='Free Trial'
export AZURE_STORAGE_ACCOUNT='capgeminiapollo'
export AZURE_STORAGE_CONTAINER='images'
export AZURE_LOCATION='North Europe'
export AZURE_SOURCE_IMAGE='Ubuntu Server 14.04.3-LTS'
export AZURE_INSTANCE_TYPE='Small'
export APOLLO_VERSION=0.2.0
```

in packer folder run the below command:

```
packer build ubuntu-14.04_amd64-azure.json
```

#### SSH'ing to your private instances

As part of `apollo-launch.sh` an SSH config file will be generated in `$APOLLO_ROOT/terraform/azure/ssh.config`.

If your master instance has a private IP of 10.0.1.11 (for example), You can SSH directly to that instance by doing the following -

```
ssh -F $APOLLO_ROOT/terraform/azure/ssh.config 10.0.1.11
```

This will proxy your SSH command via the Bastion server and you should land in the master private instance.
