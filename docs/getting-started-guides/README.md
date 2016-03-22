IaaS Provider  | Config. Mgmt | OS     | Networking  | Docs                                                   | Support Level                | Notes
-------------- | ------------ | ------ | ----------  | ----------------------------------------------------   | ---------------------------- | -----
AWS            | Ansible       | CoreOS | Weave       | [docs](../../docs/getting-started-guides/aws.md)       | Project                      | AWS private VPC with NAT gateway server for SSH/VPN
AWS Public Cloud   | Ansible      | CoreOS | Weave       | [docs](../../docs/getting-started-guides/aws-public.md)   | Project                      | Public cloud instances
Vagrant        | Ansible      | CoreOS | Weave       | [docs](../../docs/getting-started-guides/vagrant.md)    | Project                      |
Digitalocean   | Ansible      | CoreOS | Weave       | [docs](../../docs/getting-started-guides/digitalocean.md)   | Project                      | Public cloud instances


Definition of columns:

  - **IaaS Provider** is who/what provides the virtual or physical machines (nodes) that Apollo runs on.
  - **OS** is the base operating system of the nodes.
  - **Config. Mgmt** is the configuration management system that helps install and maintain apollo software on the
    nodes.
  - **Networking** is what implements the networking model.  Those with networking type
    _none_ may not support more than one node, or may support multiple VM nodes only in the same physical node.
  - Support Levels
    - **Project**:  Apollo Committers regularly use this configuration, so it usually works with the latest release
      of Apollo.
    - **Commercial**: A commercial offering with its own support arrangements.
    - **Community**: Actively supported by community contributions. May not work with more recent releases of Apollo.
    - **Inactive**: No active maintainer.  Not recommended for first-time Apollo users, and may be deleted soon.
