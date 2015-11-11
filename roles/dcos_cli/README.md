Frameworks
=========

Install mesos frameworks via capgemini:dcos-cli.

Requirements
------------

The tasks inside the role should be run only once, i.e run_once=true

Role Variables
--------------
```
dcos_cli_image: capgemini/dcos-cli
dcos_cli_zk_master_peers: "zk://{{ zookeeper_peers_nodes }}/mesos"
dcos_cli_mesos_master_url: "http://{{ ansible_ssh_host }}:5050"
dcos_cli_marathon_url: "http://{{ ansible_ssh_host }}:8080"

frameworks_FRAMEWORK-NAME_enabled: false
```

License
-------

MIT

