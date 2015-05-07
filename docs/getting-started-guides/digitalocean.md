## Getting started on Digital Ocean

### Prerequisites

1. You need an Digital Ocean account. Visit [https://cloud.digitalocean.com/registrations/new](https://cloud.digitalocean.com/registrations/new) to get started
2. You need an Atlas account. Visit [https://atlas.hashicorp.com](https://atlas.hashicorp.com) to get started.
4. You need to have installed and configured Terraform (>= 0.4.2 recommended). Visit [https://www.terraform.io/intro/getting-started/install.html](https://www.terraform.io/intro/getting-started/install.html) to get started.
4. You need to have [Packer](https://www.packer.io) installed.
5. You need to have [Python](https://www.python.org/) >= 2.7.5 installed.
6. The latest version of Ansible (for provisioning) installed (>= 1.9.0) [http://docs.ansible.com/intro_installation.html](http://docs.ansible.com/intro_installation.html) to get started. Do not install 1.9.1 [https://github.com/ansible/ansible-modules-core/issues/1170](https://github.com/ansible/ansible-modules-core/issues/1170)
7. You need to have [dopy](https://github.com/devo-ps/dopy) installed.
8. You will need to have created an SSH RSA key pair for accessing your Digitalocean
droplets. Execute ```ssh-keygen -t rsa``` to create a key pair.


### Cluster Startup

#### Download Apollo

##### Install from source at head
1. ```git clone https://github.com/Capgemini/apollo.git```
2. ```cd apollo```

#### Build the base image in Atlas

We are using [Atlas](https://atlas.hashicorp.com) to store artifacts (images) for
builds.

You will need to push and build your Atlas artifact (via Packer in the Atlas cloud) in order to
provision your nodes via terraform. See the [guide on how to build artifacts in Atlas](../../docs/atlas.md)

#### Set config

Configuration can be set via environment variables. For a full list of available config
options for Digital Ocean see ```bootstrap/digitalocean/config-default.sh```

As a minimum you will need to set these environment variables -

```
# v2 API token
DIGITALOCEAN_API_TOKEN=
```

To generate a v2 API token see [https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocea n-api-v2](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2)

```
# v1 API credentials as needed by ansible dynamic inventory.
DO_CLIENT_ID=
DO_API_KEY=
```

To generate a v1 API credentials see [https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-deprecated](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-deprecated)

```
APOLLO_PROVIDER=digitalocean

# Path to your public ssh key (created in prerequisite step 8 above).
DIGITALOCEAN_SSH_KEY=

# Atlas variables.
ATLAS_TOKEN=
ATLAS_INFRASTRUCTURE=
ATLAS_ARTIFACT_MASTER=
ATLAS_ARTIFACT_SLAVE=
```

#### Start up the cluster
```
sh bootstrap/apollo-launch.sh
```

NOTE: The script will provision a 3 node mesos master cluster in lon1 (UK). It will also create a mesos slave cluster and a SSH key so you can access the droplets.


#### Tearing down the cluster
```
sh bootstrap/apollo-down.sh
```
