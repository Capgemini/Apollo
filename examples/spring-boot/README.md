## Spring Boot example

This example shows how to deploy spring boot application using Apollo and Marathon Mesos framework.

The example includes -

* A custom spring boot application

We'll use the [spring-boot](https://registry.hub.docker.com/u/capgemini/apollo-spring-boot/) [Docker](https://www.docker.com/) image.

The examples are to be deployed on top of the Marathon Mesos framework.

### Start the Spring Boot Application

Start the services by running the following command (from somewhere you can access the REST interface of Marathon). Replace $MARATHON_IP with the actual hostname/ip address of the marathon instance.
Marathon by default should be deployed in the ```mesos_master``` nodes.

```
curl -X POST -HContent-Type:application/json -d @spring-boot.json http://$MARATHON_IP:8080/v2/apps
```

The service will be accessible through the HAProxy container (on port 80) at ```springboot.example.com``` by default. It is recommended that you set up your own DNS servers / hostname and override the ```haproxy_domain``` in [../roles/haproxy/defaults/main.yml](../roles/haproxy/defaults/main.yml).

### For cloud instances

To access the Spring Boot application, go to the Marathon dashboard at ```http://$MARATHON_IP:8080/#apps``` and click on ```/springboot```. You should see an IP address and Port in the service definition, if you click on it you should be redirected to the spring boot application.

### For Vagrant only

If you are deploying this example in the Vagrant environment, simply add the following entry to your host machine in ```/etc/hosts```

```
172.31.1.14 springboot.example.com
```

Where ```172.31.1.14``` is the Slave IP address configured in ```vagrant.yml```
If you access ```springboot.example.com``` through your browser that will hit the Haproxy container
running on the slave machine which will forward the traffic to the Drupal docker container.

### Removing the apps

You can remove the applications straight from the command line by running -

```
curl -XDELETE http://$MARATHON_IP:8080/v2/apps/springboot
```
