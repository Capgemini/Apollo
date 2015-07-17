Role Name
=========

Install mesos frameworks via capgemini:dcos-cli.

Requirements
------------

The tasks inside the role should be run only once, i.e run_once=true

Role Variables
--------------

frameworks_dcos_cli_image: capgemini/dcos-cli
frameworks_zk_master_peers: "zk://{{ zookeeper_peers_nodes }}/mesos"
frameworks_mesos_master_url: "http://{{ ansible_ssh_host }}:5050"
frameworks_marathon_url: "http://{{ ansible_ssh_host }}:8080"

frameworks_FRAMEWORK-NAME_enabled: false

License
-------

BSD

