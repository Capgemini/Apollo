## Drupal / MySQL example

This example shows how to deploy a multi-tier Drupal web app using Apollo and Marathon Mesos framework.

| Example                 | Description                                  | Example URL
|-------------------------|----------------------------------------------|--------------------------
| commerce-kickstart.json | Commerce kickstart web container, with mysql  backend container | commerce-kickstart.example.com
| drupal7.json            | Drupal7 bare web container, with mysql backend container | drupal7.example.com
| drupal8.json            | Drupal8 bare web container, with mysql backend container | drupal8.example.com

These examples includes -

* A web frontend (Using Drupal7/Drupal8/Drupal Commerce Kickstart distribution)
* A MySQL (5.5) backend

Each example is very similar, for the purposes of this document we will explain how to get the Commerce Kickstart application up and running. The same steps apply for Drupal7 and Drupal8 core.

We'll use the [mysql](https://registry.hub.docker.com/_/mysql/) official [Docker](https://www.docker.com/) image and an [apollo-commerce-kickstart](https://registry.hub.docker.com/u/capgemini/apollo-commerce-kickstart/) image which contains [php-apache](https://registry.hub.docker.com/_/php/), Drush and [Commerce Kickstart](https://www.drupal.org/project/commerce_kickstart).

The examples are to be deployed on top of the Marathon Mesos framework.

### Start the services

First, edit ```commerce-kickstart.json```, in the mysql app service definition, to use database credentials that you specify (or leave as is if you are happy and this is just for demo purposes).

If you changed the database credentials as above, then edit the drupal app definition in ```commerce-kickstart.json```, to use database credentials that you specify (or leave as is if you are happy and this is just for demo purposes).

Start the services by running the following command (from somewhere you can access the REST interface of Marathon). Replace $MARATHON_IP with the actual hostname/ip address of the marathon instance.
Marathon by default should be deployed in the ```mesos_master``` nodes.

```
curl -X POST -HContent-Type:application/json -d @commerce-kickstart.json $MARATHON_IP:8080/v2/groups
```

This should spin up a separate Drupal Docker container that is communicating to the MySQL container using the Consul DNS address ```commerce-kickstart.mysql.service.consul``` by default.

The service will be accessible through the HAProxy container (on port 80) at ```commerce-kickstart.example.com``` by default. It is recommended that you set up your own DNS servers / hostname and override the ```haproxy_domain``` in [../roles/haproxy/defaults/main.yml](../roles/haproxy/defaults/main.yml).

### For cloud instances

If you are running the application in the cloud make sure you have enough compute power in your cluster to handle the web applications and the databases. We have tested running up the following example in AWS on a 5 node cluster (3 master / 2 slave) using ```c3.large``` compute instances, which work well enough for demo purposes.

To access the Drupal site, you will either need to have DNS set up or map either the ELB or the slave instance IP to your ```/etc/hosts``` file. Go grab the IP address and map it to


```
SLAVE_IP_HOST commerce-kickstart.example.com
```

### For Vagrant only

If you are deploying this example in the Vagrant environment, simply add the following entry to your host machine in ```/etc/hosts```

```
172.31.1.14 commerce-kickstart.example.com
```

Where ```172.31.1.14``` is the Slave IP address configured in ```vagrant.yml```
If you access ```drupal.example.com``` through your browser that will hit the Haproxy container
running on the slave machine which will forward the traffic to the Drupal docker container.

### Installing the Drupal database

By default the database will not be pre-populated. To install the site either:

1. Navigate to ```commerce-kickstart.example.com``` (or whatever you have your DNS set up as) and follow the on-screen instructions to install the site
2. Login to the docker container and install the site via Drush. To do this -
  - Navigate to the slave machine the container is running on
  - Get the container id: ```docker ps | grep drupal```
  - Login to the container: ```docker exec -it $CONTAINER_ID /bin/bash```
  - Install the site:
  ```drush site-install commerce_kickstart --site-name=default --account-pass=changeme -y```

### Removing the apps

You can remove the applications straight from the command line by running -

```
curl -XDELETE http://$MARATHON_IP:8080/v2/groups/commerce-kickstart
```
