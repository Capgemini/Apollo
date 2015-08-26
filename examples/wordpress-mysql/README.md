## Wordpress / MySQL example

This example shows how to deploy Wordpress & MySQL using Apollo and Marathon Mesos framework.

This examples includes two Docker containers -

* A web frontend using the latest version of WordPress
* A MySQL (5.5) backend


We'll use the [MySQL](https://registry.hub.docker.com/_/mysql/) official [Docker](https://www.docker.com/) image and an [WordPress](https://registry.hub.docker.com/_/wordpress/) image which contains [php-apache](https://registry.hub.docker.com/_/php/), and the latest version of [WordPress](https://wordpress.org/).

This example is to be deployed on top of the Marathon Mesos framework.

### Start the services

First, edit ```wordpress.json```, in the mysql app service definition, to use database credentials that you specify (or leave as is if you are happy and this is just for demo purposes).

If you changed the database credentials as above, then edit the WordPress app definition in ```wordpress.json```, to use database credentials that you specify (or leave as is if you are happy and this is just for demo purposes).

Start the services by running the following command (from somewhere you can access the REST interface of Marathon). Replace $MARATHON_IP with the actual hostname/ip address of the marathon instance.
Marathon by default should be deployed in the ```mesos_master``` nodes.

```
curl -X POST -HContent-Type:application/json -d @wordpress.json $MARATHON_IP:8080/v2/groups
```

This should spin up a separate WordPress Docker container that is communicating to the MySQL container using the Consul DNS address ```wordpress.mysql.service.consul``` by default.

The service will be accessible through the HAProxy container (on port 80) at ```wordpress.example.com``` by default. It is recommended that you set up your own DNS servers / hostname and override the ```haproxy_domain``` in [../roles/haproxy/defaults/main.yml](../roles/haproxy/defaults/main.yml).

### For cloud instances

If you are running the application in the cloud make sure you have enough compute power in your cluster to handle the web applications and the databases. We have tested running up the following example in AWS on a 5 node cluster (3 master / 2 slave) using ```c3.large``` compute instances, which work well enough for demo purposes.

To access the WordPress site, you will either need to have DNS set up or map either the ELB or the slave instance IP to your ```/etc/hosts``` file. Go grab the IP address and map it to


```
SLAVE_IP_HOST wordpress.example.com
```

### For Vagrant only

If you are deploying this example in the Vagrant environment, simply add the following entry to your host machine in ```/etc/hosts```

```
172.31.1.14 wordpress.example.com
```

Where ```172.31.1.14``` is the Slave IP address configured in ```vagrant.yml```
If you access ```wordpress.example.com``` through your browser that will hit the Haproxy container
running on the slave machine which will forward the traffic to the WordPress docker container.

### Installing WordPress

By default WordPress will not be installed. To install the site:

Navigate to ```wordpress.example.com``` (or whatever you have your DNS set up as) and follow the on-screen instructions to install the site.

### Removing the apps

You can remove the applications straight from the command line by running -

```
curl -XDELETE http://$MARATHON_IP:8080/v2/groups/wordpress
```
