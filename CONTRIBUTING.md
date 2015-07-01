How to contribute
=================

Apollo is based on an strong open-source philosophy so we would love your contributions.

## Apollo Core

Apollo is built on top of several opensource tecnologies:

* [Packer](https://packer.io) for automating the build of the base images
* [Terraform](https://www.terraform.io/) for provisioning the infrastructure
* [Apache Mesos](http://mesos.apache.org/) for cluster management, scheduling and resource isolation
* [Consul](http://consul.io) for service discovery, DNS
* [Docker](http://docker.io) for application container runtimes
* [Weave](https://github.com/zettio/weave) for networking of docker containers

We want Apollo core to be as slim as possible providing a cloud agnostic Mesos cluster with an autodiscovery system based on consul for multi-service tasks.

This reduces the impact of core changes allowing the user to customise Apollo behaviour via plugins for satisfying the requirements of a given project.

If you find an issue belonging to any of the tools used by Apollo please, refer to the pertinent project.

## Contributing to Apollo Core

* Submit an issue describing your proposed change to the Apollo repo.

* Fork the repo, develop and test your feature.

* Submit a pull request.


## Developing Apollo Plugins

We want Apollo to be as pluggable as possible making contributions easier via core-agnostic plugins giving them freedom and flexibility regarding isolated testing, development and release management.

A new Apollo plugin is purely an Ansible role stuck to some Apollo conventions and hooked into an Apollo deploy.

* Create the new ansible role:

At the moment we rely on [ansible-galaxy](http://docs.ansible.com/galaxy.html) for generating scaffolder, we might be providing a custom tool for generating a scaffolder matching better the Apollo conventions soon.

```yml
ansible-galaxy init marathon
```

Write your code e.g yet another framework on top of Mesos and push it into its own git repo.

* Hook up a the new plugin adding your role into contrib-plugins/plugins.yml. For more info see [advanced-control-over-role-requirements-files](http://docs.ansible.com/galaxy.html#advanced-control-over-role-requirements-files). E.g:

```yml
# Apollo plugins.
- src: https://github.com/Capgemini/your-plugin-repo.git
  path: contrib-plugins/roles
  name: marathon
```

* Add the plugin into the playbook by editing contrib-plugins/playbook.yml like:

```yml
- hosts: mesos_masters
  roles:
    - marathon
```

* You can now put "contrib-plugins" folder under a control version system.

* Test your new plugin by running:

```
ansible-galaxy install -r contrib-plugins/plugins.yml
/bin/bash apollo_launch.sh
```

## Best practices.

* When creating a new plugin we are keen on using the ansible role for deploying Mesos frameworks inside containers so we achieve total flexibility, reusability and portabilty across operating systems.

```yml
# tasks for running docker marathon
- name: run marathon container
  when: marathon_enabled
  docker:
    name: marathon
    image: "{{ marathon_image }}"
    state: started
    restart_policy: "{{ marathon_restart_policy }}"
    ports:
    - "{{ marathon_port }}:{{ marathon_port }}"
    expose:
    - "{{ marathon_port }}"
    net: "{{ marathon_net }}"
    command: "{{ marathon_command }}"
    volumes:
    - "{{ marathon_artifact_store_dir }}:/store"
    - "/var/run/docker.sock:/tmp/docker.sock"
    memory_limit: "{{ marathon_container_memory_limit }}"
    env:
      JAVA_OPTS: "{{ marathon_java_settings }}"
  notify:
    - wait for marathon to listen
```

* The variables in the role following the pattern:

```yml
pluginname_variablename: value
```

will be automatically overridable via environment variables using the pattern "APOLLO_PLUGINNAME_VARNAME". Every plugin should provide the capacity for been enabled or disabled via these variables e.g:

```yml
marathon_enabled: true
marathon_version: '0.9.0-RC3'
``` 

* It's usually a good idea [attach a process manager to manage it](https://docs.docker.com/articles/host_integration/)

```
description "Marathon container"

start on started docker
stop on stopping docker

script
  /usr/bin/docker start -a marathon
end script

respawn
respawn limit 10 10
kill timeout 10
```

```yml
- name: ensure marathon is running (and enable it at boot)
  when: marathon_enabled
  sudo: yes
  service:
    name: marathon
    state: started
    enabled: yes
  tags:
    - marathon
```

* Your plugin must ensure state is consistent when it is disabled, e.g:
```yml
- name: ensure marathon is stopped
  when: not marathon_enabled
  sudo: yes
  service:
    name: marathon
    state: stopped
    enabled: yes
  tags:
    - marathon
```

* Create Consul Healchecks

```json
{
  "service": {
    "name": "marathon",
    "tags": [ "marathon" ],
    "port": {{ marathon_port }},
    "check": {
      "script": "curl --silent --show-error  --fail --dump-header /dev/stderr --retry 2 http://{{ marathon_hostname }}:{{ marathon_port }}/ping",
      "interval": "10s"
    }
  }
}
```

## Contributing a new Apollo Plugin

* Apollo gives only official support for core plugins.

* If you think your plugin should be part of Apollo core plugins please create a new issue describing your feature, and explaining the motivation.

* You can hook up your own plugins into Apollo even if they are not core plugins as explained in section above.
