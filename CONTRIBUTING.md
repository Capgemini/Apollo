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

This reduces the impact of core changes allowing the user customise Apollo behaviour via plugins for satisfying the requirements of a given project.

If you find an issue belonging to any of the tools used by Apollo please, refer to the project in question.

## Contributing to Apollo Core

* Submit an issue describing your proposed change to the Apollo repo.

* Fork the repo, develop and test your feature.

* Submit a pull request.

## Contributing to Apollo Core Plugins

* Create a new issue describing your proposed change to the plugin repo.

* Fork the repo, develop and test your feature.

* Create a pull request.

## Developing Apollo Plugins

We want Apollo to be as pluggable as possible making contributions easier via core-agnostic plugins giving them freedom and flexibility regarding isolated testing, development and release management.

A new Apollo plugin is purely an Ansible role stuck to some Apollo conventions and hooked into an Apollo deploy.

* Generate your plugin scaffolder:

At the moment we rely on [ansible-galaxy](http://docs.ansible.com/galaxy.html) for generating the plugin scaffolder, we will be providing a custom tool for generating a scaffolder for matching better the Apollo conventions soon.

```yml
ansible-galaxy init marathon
```

* Hook up a the new plugin e.g yet another framework on top of Mesos into Apollo adding your role in the plugins.yml. For more info see [advanced-control-over-role-requirements-files](http://docs.ansible.com/galaxy.html#advanced-control-over-role-requirements-files). E.g:

```yml
# Apollo core plugins.
- src: https://github.com/Capgemini/apollo-core-plugin-marathon.git
  path: ./plugins
  name: marathon
```

* Add the plugin into the playbook editing site.yml like:

```yml
- hosts: mesos_masters
  roles:
    - { role: mesos, mesos_install_mode: "master", tags: ["mesos-master"] }
    - zookeeper
    - { role: '../plugins/marathon' }
```


## Best practices.

* When creating a new plugin we are keen on using the ansible role for deploying Mesos frameworks inside containers so we achieve total flexibility, reusability and portabilty across operating systems.

```yml
# tasks for running docker marathon
- name: run marathon container
  when: marathon_enabled == "Y"
  docker:
    name: marathon
    image: "{{ marathon_image }}"
    state: started
    restart_policy: always
    ports:
    - "{{ marathon_port }}:{{ marathon_port }}"
    net: host
    command: "--master {{marathon_master_peers}} --zk {{marathon_zk_peers}}"
    hostname: "{{ hostname }}"
    volumes:
    - "/var/run/docker.sock:/tmp/docker.sock"
```

* The variables in the role following the pattern:

```yml
pluginname_variablename: value
```

will be automatically overridable via environment variables using the pattern "APOLLO_PLUGINNAME_VARNAME". Every plugin should provide the capacity for been enabled or disabled via these variables e.g:

```yml
marathon_enabled: 'Y'
marathon_version: 'v0.8.1'
``` 

* Your plugin must ensure state is consistent when it is disabled, e.g:
```yml
- name: stop marathon container
  when: marathon_enabled == "N"
  docker:
    name: marathon
    image: "{{ marathon_image }}"
    state: stopped
```


## Contributing a new Apollo Plugin

* Apollo gives official support only for core plugins.

* If you think your plugin should be part of Apollo core plugins please create a new issue describing your feature, and explaining the motivation.

* You can hook up your own plugins into Apollo even if they are not core plugins as explained in section above.
