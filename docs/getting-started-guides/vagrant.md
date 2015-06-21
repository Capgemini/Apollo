## Getting started on Vagrant

Running Apollo with Vagrant (and Virtualbox) is an easy way to run/test/develop on your local machine (Linux, Mac, OS X)

### Prerequisites

1. The latest version of vagrant installed (>= 1.7.2) [http://www.vagrantup.com/downloads.html](http://www.vagrantup.com/downloads.html) to get started
2. Install vagrant-hostmanager plugin ```vagrant plugin install vagrant-hostmanager```
3. The latest version of Virtualbox from [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
4. You need to have [Python](https://www.python.org/) >= 2.7.5 installed along with [pip](https://pip.pypa.io/en/latest/installing.html).

### Cluster Turnup

#### Download Apollo

##### Install from source at head
1. ```git clone https://github.com/Capgemini/Apollo.git```
2. ```cd Apollo```
3. ```pip install -r requirements.txt```

_Note: you may need to run the pip command with Admin priviledges (e.g. sudo ... if you're on a *nix machine)._

#### Turn up the cluster
```
export APOLLO_PROVIDER=vagrant
sh bootstrap/apollo-launch.sh
```

Note: When using vagrant-hosts plugin, you will either have to run the above command as sudo or have your hosts file writeable for the user running the command

Vagrant will set up a 3 node mesos-master cluster and 1 mesos-slave. By default the master nodes will each take up 256MB and 1 CPU. The slave will take 1024MB and 2 CPUs.

By default the web interfaces should be available on -

- [http://master1:5050](http://master1:5050) (Mesos)
- [http://master1:8080](http://master1:8080) (Marathon)
- [http://master1:8500](http://master1:8500) (Consul)

Mesos / Marathon should handle redirection the the leader node automatically via Zookeeper.

To tweak these settings you may modify ```vagrant.yml```


#### Tearing down the cluster
```
sh bootstrap/apollo-down.sh
```

#### Interacting with your Apollo cluster with Vagrant

You can interact with your Apollo cluster via the normal vagrant commands - ```vagrant up``` ```vagrant halt``` ```vagrant destroy``` etc...

#### Adding more slave machines

Edit ``vagrant.yml```

Add a new ip under ```slaves.ips:``` following the ip´s convention (i.e. 172.31.1.15).

#### Using Apollo Behind a Firewall

Edit ``groups_vars/all```

Change all the ```proxy_env``` variables to the proxy hostname e.g. http://10.99.11.11:9090
