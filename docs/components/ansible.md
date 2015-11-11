## Ansible

We use [Ansible](http://docs.ansible.com/) to handle provisioning of instances in the cloud after they are spun up via [Terraform](terraform.md).

Ansible is responsible for placing any config files in place, and starting up the relevant services on each type of node.

The main decision behind choosing Ansible is the fact that only Python (2.6 or later) as well as Ansible installed is required on the control machine, and only Python (2.4 or later) is required on the remote machine.

Due to the fact Python comes as standard on most operating systems there are no external dependencies to running Ansible. Since Ansible also uses just SSH to execute the remote commands it is very easy/quick to get installed and up and running.

The other main reason is the use of [Ansible Dynamic Inventory](http://docs.ansible.com/intro_dynamic_inventory.html). This allows us to query remote cloud APIs to build Ansible host files, thus meaning we can keep IP addresses/host information completely out of configuration files.

The ability to mix static inventory and dynamic inventory (See [http://docs.ansible.com/intro_dynamic_inventory.html#static-groups-of-dynamic-groups](http://docs.ansible.com/intro_dynamic_inventory.html#static-groups-of-dynamic-groups)) also gives us complete flexibility to map a static group of roles (e.g. mesos/zookeeper/weave etc.) on to dynamic host IPs (provisioned in the cloud).

To view the default Ansible playbook see [site.yml](../../site.yml).
The main Ansible configuration lies in the following directories:

- [inventory](../../inventory)
- [roles](../../roles)
- [group_vars](../../group_vars)
