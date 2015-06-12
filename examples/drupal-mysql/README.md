## Drupal / MySQL example

This example shows how to deploy a multi-tier Drupal web app using Apollo and Marathon Mesos framework.

The example includes -

* A web frontend (Using Drupal Commerce Kickstart distribution)
* A MySQL (5.5) backend

We'll use the [mysql](https://registry.hub.docker.com/_/mysql/) official [Docker](https://www.docker.com/) image and an [apollo-commerce-kickstart](https://registry.hub.docker.com/u/capgemini/apollo-commerce-kickstart/) image which contains [php-apache](https://registry.hub.docker.com/_/php/), Drush and [Commerce Kickstart](https://www.drupal.org/project/commerce_kickstart).

The examples are to be deployed on top of the Marathon Mesos framework.

### Start the Drupal and MySQL services

First, edit ```drupal-mysql.json```, in the mysql app service definition, to use database credentials that you specify (or leave as is if you are happy and this is just for demo purposes).

If you changed the database credentials as above, then edit the drupal app definition in ```drupal-mysql.json```, to use database credentials that you specify (or leave as is if you are happy and this is just for demo purposes).

Start the services by running the following command (from somewhere you can access the REST interface of Marathon). Replace $MARATHON_IP with the actual hostname/ip address of the marathon instance.
Marathon by default should be deployed in the ```mesos_master``` nodes.

```
curl -X POST -HContent-Type:application/json -d @drupal-mysql.json $MARATHON_IP:8080/v2/groups
```

This should spin up a separate Drupal Docker container that is communicating to the MySQL container using the Consul DNS address ```mysql.service.consul``` by default.

The service will be accessible through the HAProxy container (on port 80) at ```drupal.example.com``` by default. It is recommended that you set up your own DNS servers / hostname and override the ```haproxy_domain``` in [../roles/haproxy/defaults/main.yml](../roles/haproxy/defaults/main.yml).

### For cloud instances

To access the Drupal site, go to the Marathon dashboard at ```http://$MARATHON_IP:8080/#apps``` and click on ```/drupal-mysql-example/drupal```. You should see an IP address and Port in the service definition, if you click on it you should be redirected to the Drupal installation screen.

### For Vagrant only

If you are deploying this example in the Vagrant environment, simply add the following entry to your host machine in ```/etc/hosts```

```
172.31.1.14 drupal.example.com
```

Where ```172.31.1.14``` is the Slave IP address configured in ```vagrant.yml```
If you access ```drupal.example.com``` through your browser that will hit the Haproxy container
running on the slave machine which will forward the traffic to the Drupal docker container.

### Installing the Drupal database

By default the database will not be pre-populated. To install the site either:

1. Navigate to ```drupal.example.com``` (or whatever you have your DNS set up as) and follow the on-screen instructions to install the site
2. Login to the docker container and install the site via Drush. To do this -
  - Navigate to the slave machine the container is running on
  - Get the container id: ```docker ps | grep drupal```
  - Login to the container: ```docker exec -it $CONTAINER_ID /bin/bash```
  - Install the site:
  ```drush site-install commerce_kickstart --site-name=default --acount-pass=changeme -y```

### Removing the apps

You can remove the applications straight from the command line by running -

```
curl -XDELETE http://$MARATHON_IP:8080/v2/groups/drupal-mysql-example
```
