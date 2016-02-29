## Rolling upgrades of the platform

we provide two playbooks for upgrading the differents components of the platform with ease.

You can specify which bits to upgrade by using ansible tags. E.g:
``` export ANSIBLE_TAGS=weave,mesos_maintenance```

### Software maintenance of the cluster

``` /bin/bash bootstrap/apollo-launch.sh ansible_upgrade_maintenance ```

By using ```mesos_maintenance``` Apollo assumes you have schedule a [Mesos maintenance](http://mesos.apache.org/documentation/latest/maintenance/).

Apollo will [set the machine down](http://mesos.apache.org/documentation/latest/endpoints/master/machine/down/), run ansible, and [set the machine up](http://mesos.apache.org/documentation/latest/endpoints/master/machine/up/) squentially in every host.

### Upgrading Mesos/Marathon

``` /bin/bash bootstrap/apollo-launch.sh ansible_upgrade_mesoscluster ```

TODOs:

* Consul Maintenance.
* Handle systemd dependencies explicitly.
