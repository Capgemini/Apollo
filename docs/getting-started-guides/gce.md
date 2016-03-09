## Getting started on GCE

### Prerequisites

1. You need an Google account. Visit [https://accounts.google.com](https://accounts.google.com) to get started
3. You need to have installed and configured Terraform (>= 0.6.10 recommended). Visit [https://www.terraform.io/intro/getting-started/install.html](https://www.terraform.io/intro/getting-started/install.html) to get started.
4. You will need a VPN client if you want to access the web interfaces for Mesos, Consul and Marathon. We recommend using Tunnelblick. Visit [https://code.google.com/p/tunnelblick/](https://code.google.com/p/tunnelblick/) to download and install.
5. You need to have [Python](https://www.python.org/) >= 2.7.5 installed along with [pip](https://pip.pypa.io/en/latest/installing.html).

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

For a full list of default config options for GCE see `bootstrap/gce/config-default.sh`

As a minimum you will need to set these environment variables -

```
APOLLO_PROVIDER=gce
TF_VAR_account_file
TF_VAR_project
```

#### Turn up the cluster
Create a new Project using the [Google Developer Console](https://console.developers.google.com/project)

Download [Google Cloud SDK](https://cloud.google.com/sdk/)

Run:

```bash
gcloud auth login
gcloud config set project-id
```

Next command makes deploy user able to login into  any VM for the current project:

```bash
gcloud compute ssh deploy@apollo-mesos-master-0
```

Make sure you add the google ssh key to the ssh-agent so it is available for Ansible to use it:

```bash
ssh-add ~/.ssh/google_compute_engine
```

And:

```bash
/bin/bash bootstrap/apollo-launch.sh
```

#### Tearing down the cluster

```bash
/bin/bash bootstrap/apollo-down.sh
```
