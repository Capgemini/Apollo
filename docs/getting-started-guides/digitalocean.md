## Getting started on Digital Ocean

### Prerequisites

1. You need an Digital Ocean account. Visit [https://cloud.digitalocean.com/registrations/new](https://cloud.digitalocean.com/registrations/new) to get started
2. You need an Atlas account. Visit [https://atlas.hashicorp.com](https://atlas.hashicorp.com) to get started.
4. You need to have installed and configured Terraform (>= 0.5.0 recommended). Visit [https://www.terraform.io/intro/getting-started/install.html](https://www.terraform.io/intro/getting-started/install.html) to get started.
4. You need to have [Packer](https://www.packer.io) installed.
5. You need to have [Python](https://www.python.org/) >= 2.7.5 installed along with [pip](https://pip.pypa.io/en/latest/installing.html).
6. You will need to have created an SSH RSA key pair for accessing your Digitalocean
droplets. Execute ```ssh-keygen -t rsa``` to create a key pair.

### Cluster Startup

#### Download Apollo

##### Install from source at head
1. ```git clone https://github.com/Capgemini/apollo.git```
2. ```cd apollo```
3. ```pip install -r requirements.txt```

#### Build the base image in Atlas

We are using [Atlas](https://atlas.hashicorp.com) to store artifacts (images) for
builds.

You will need to push and build your Atlas artifact (via Packer in the Atlas cloud) in order to
provision your nodes via terraform. See the [guide on how to build artifacts in Atlas](../../docs/atlas.md)

When using ```atlas_artifact``` in Terraform, Terraform is looking up the Atlas artifact to retrieve the Digitalocean image ID to replace it in the ```image``` field. If you need to debug to see which images are available under your Digitalocean account you can run the following from your terminal -

```
curl -X GET -H 'Content-Type: application/json' -H 'Authorization: Bearer $DIGITALOCEAN_API_TOKEN' "https://api.digitalocean.com/v2/images?page=1&per_page=1&private=true"
```

replacing ```$DIGITALOCEAN_API_TOKEN``` with your v2 API token.

#### Set config

Configuration can be set via environment variables.

All variables following the pattern "TF_VAR_" will be available for Apollo in terraform, see [https://github.com/hashicorp/terraform/pull/1621#issuecomment-100825568](https://github.com/hashicorp/terraform/pull/1621#issuecomment-100825568)

All variables following the pattern "APOLLO_" will be available for Apollo in ansible.

For a full list of default config options for Digital Ocean see ```bootstrap/digitalocean/config-default.sh```

As a minimum you will need to set these environment variables -

```
# v2 API token

TF_VAR_do_token=

```
To generate a v2 API token see [https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocea n-api-v2](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2)


```
APOLLO_PROVIDER=digitalocean

# Path to your public ssh key (created in prerequisite step 6 above).
TF_VAR_key_file=

# Atlas variables.
ATLAS_TOKEN=
ATLAS_INFRASTRUCTURE=

TF_VAR_altas_artifact_master=
TF_VAR_atlas_artifact_slave=
TF_VAR_altas_artifact_version_master=
TF_VAR_atlas_artifact_version_slave=

```

#### Start up the cluster
```
/bin/bash bootstrap/apollo-launch.sh
```

NOTE: The script will provision a 3 node mesos master cluster in lon1 (UK) by default. It will also create a mesos slave cluster and a SSH key so you can access the droplets.


#### Tearing down the cluster
```
/bin/bash bootstrap/apollo-down.sh
```
