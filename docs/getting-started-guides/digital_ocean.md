## Getting started on Digital Ocean

### Prerequisites

1. You need an Digital Ocean account. Visit [https://cloud.digitalocean.com/registrations/new](https://cloud.digitalocean.com/registrations/new) to get started
2. You need an Atlas account. Visit [https://atlas.hashicorp.com](https://atlas.hashicorp.com) to get started.
3. You need to have installed and configured Terraform. Visit [https://www.terraform.io/intro/getting-started/install.html](https://www.terraform.io/intro/getting-started/install.html) to get started.
4. You need to have [Packer](https://www.packer.io) installed.
5. You need to have [Python](https://www.python.org/) >= 2.7.5 installed.
6. You need to have ansible [Ansible](http://www.ansible.com/home) installed.
7. You need to have [dopy](https://github.com/devo-ps/dopy) installed.

### Cluster Turnup

#### Download Apollo

##### Install from source at head
1. ```git clone https://github.com/Capgemini/apollo.git```
2. ```cd apollo```

#### Set config

Configuration can be set via environment variables. For a full list of available config
options for Digital Ocean see ```bootstrap/digitalocean/config-default.sh```

As a minimum you will need to set these environment variables -

```
DIGITALOCEAN_API_TOKEN=

# setup DO API credentials against v1 API as needed by ansible dynamic invetory.
APOLLO_PROVIDER=digitalocean
DO_CLIENT_ID=
DO_API_KEY=

# path to your public ssh key.
DIGITALOCEAN_SSH_KEY=

# Atlas variables.
ATLAS_TOKEN=
ATLAS_INFRASTRUCTURE=
```

By default Apollo will set the master/slave id to the latest version of your apollo image from your digital ocean account.
Otherwise you can set the id specifically as follows:
```
MASTER_IMAGE=
SLAVE_IMAGE=
```

#### Build the base image
```
cd packer
packer build ubuntu-14.04_amd64-droplet.json 
```
This will build and upload and image into your Digital Ocean account.

#### Turn up the cluster
```
sh bootstrap/apollo-launch.sh
```

NOTE: The script will provision a 3 node mesos master cluster in lon1 (UK). It will also create a mesos slave cluster and a ssh key so you can access to the droplets.


#### Tearing down the cluster
```
sh bootstrap/apollo-down.sh
```
