How to contribute
=================

Apollo is based on an strong open-source philosophy so we would love your contributions.

This project adheres to the [Open Code of Conduct](http://todogroup.org/opencodeofconduct/#Apollo/digitaldevops.uk@capgemini.com). By participating, you are expected to uphold this code.

## Apollo Core

Apollo is built on top of several opensource tecnologies:

* [Terraform](https://www.terraform.io/) for provisioning the infrastructure
* [Apache Mesos](http://mesos.apache.org/) for cluster management, scheduling and resource isolation
* [Consul](http://consul.io) for service discovery, DNS
* [Docker](http://docker.io) for application container runtimes
* [Weave](https://github.com/zettio/weave) for networking of docker containers
* [Zookeeper](https://zookeeper.apache.org/) for cconfiguration information, naming, providing distributed synchronization, and providing group services

We want Apollo core to be as slim as possible providing a cloud agnostic Mesos cluster with an autodiscovery system based on consul for multi-service tasks.

This reduces the impact of core changes allowing the user to customise Apollo behaviour via plugins for satisfying the requirements of a given project.

If you find an issue belonging to any of the tools used by Apollo please, refer to the pertinent project.

## Contributing to Apollo Core

* Submit an issue describing your proposed change to the Apollo repo.

* Fork the repo, develop and test your feature.

* Submit a pull request.

## Contributing a mesos framework

We relying on Marathon and [dcos-cli-docker](https://github.com/Capgemini/dcos-cli-docker) for installing mesos frameworks via [DCOS-CLI](https://docs.mesosphere.com/using/cli/)
See [frameworks role.](https://github.com/Capgemini/Apollo/tree/master/roles/frameworks)

For providing a new mesos framework you need to add it to the frameworks list in "default/mail.yml" e.g chronos:

```
frameworks_list:
  - cassandra
  - chronos
```

You'll need to add a template with the required configuration for the package e.g. chronos-config.j2:

```
{
  "mesos": {"master": "{{ frameworks_zk_master_peers }}"},
  "chronos": {
    "zk-hosts": "{{ zookeeper_peers_nodes }}",
    "mem": {{ frameworks_chronos_mem }}
  }
}
```

You can define the values for the config at "vars/chronos.yml". The values defined here will be overridable via environment variables, e.g

```
APOLLO_frameworks_chronos_enabled=True
```

```
frameworks_chronos_sources: '["https://github.com/Capgemini/universe/archive/develop.zip",]'
frameworks_chronos_enabled: true
frameworks_chronos_mem: 512
```


## Developing Apollo Plugins

We want Apollo to be as pluggable as possible making contributions easier via core-agnostic plugins giving them freedom and flexibility regarding isolated testing, development and release management.

A new Apollo plugin is purely an Ansible role stuck to some Apollo conventions and hooked into an Apollo deploy.

* Create the new ansible role:

At the moment we rely on [ansible-galaxy](http://docs.ansible.com/galaxy.html) for generating scaffolder, we might be providing a custom tool for generating a scaffolder matching better the Apollo conventions soon.

```yml
ansible-galaxy init marathon
```

Write the code providing the add-on feature on top of Apollo and push it into its own git repo.

* Hook up a the new plugin adding your role into contrib-plugins/plugins.yml. For more info see [advanced-control-over-role-requirements-files](http://docs.ansible.com/galaxy.html#advanced-control-over-role-requirements-files). E.g:

```yml
# Apollo plugins.
- src: https://github.com/Capgemini/your-plugin-repo.git
  path: contrib-plugins/roles
  name: cadvisor
```

* Add the plugin into the playbook by editing contrib-plugins/playbook.yml like:

```yml
- hosts: all
  roles:
    - cadvisor
```

* You can now put "contrib-plugins" folder under a control version system.

* Test your new plugin by running:

```
ansible-galaxy install -r contrib-plugins/plugins.yml
/bin/bash apollo_launch.sh
```

## Best practices.

* When creating a new plugin we are keen on using the ansible role for deploying services inside containers so we achieve total flexibility, reusability and portabilty across operating systems.

```yml
# tasks for running cadvisor
- name: run cadvisor container
  when: cadvisor_enabled
  docker:
    name: cadvisor
    image: "{{ cadvisor_image }}"
    state: started
    restart_policy: "{{ cadvisor_restart_policy }}"
    net: "{{ cadvisor_net }}"
    ports:
      - "{{ cadvisor_host_port }}:8080"
    hostname: "{{ cadvisor_hostname }}"
    volumes:
    - "/var/lib/docker/:/var/lib/docker:ro"
    - "/:/rootfs:ro"
    - "/var/run:/var/run:rw"
    - "/sys:/sys:ro"
  tags:
    - cadvisor
```

* The variables in the role following the pattern:

```yml
pluginname_variablename: value
```

will be automatically overridable via environment variables using the pattern "APOLLO_PLUGINNAME_VARNAME". Every plugin should provide the capacity for been enabled or disabled via these variables e.g:

```yml
cadvisor_enabled: true
cadvisor_version: 'latest'
```

* It's usually a good idea [attach a process manager to manage it](https://docs.docker.com/articles/host_integration/)

```
description "cadvisor container"

start on started docker
stop on stopping docker

script
  /usr/bin/docker start -a cadvisor
end script

respawn
respawn limit 10 10
kill timeout 10
```

```yml
- name: ensure cadvisor is running (and enable it at boot)
  when: cadvisor_enabled
  sudo: yes
  service:
    name: cadvisor
    state: started
    enabled: yes
  tags:
    - cadvisor
```

* Your plugin must ensure state is consistent when it is disabled, e.g:
```yml
- name: ensure cadvisor is running (and enable it at boot)
  when: not cadvisor_enabled
  sudo: yes
  service:
    name: cadvisor
    state: stopped
    enabled: yes
  tags:
    - cadvisor
```

* Create Consul Healchecks

```json
{
  "service": {
    "name": "cadvisor",
    "tags": [ "cadvisor" ],
    "port": {{ cadvisor_host_port }},
    "check": {
      "script": "curl --silent --show-error  --fail --dump-header /dev/stderr --retry 2 http://{{ cadvisor_hostname }}:{{ cadvisor_host_port}}",
      "interval": "10s"
    }
  }
}
```

## Contributing a new Apollo Plugin

* Apollo gives only official support for core plugins.

* If you think your plugin should be part of Apollo core plugins please create a new issue describing your feature, and explaining the motivation.

* You can hook up your own plugins into Apollo even if they are not core plugins as explained in section above.
