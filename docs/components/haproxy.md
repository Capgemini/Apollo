## HAProxy

We use HAProxy as a load balancer to service external requests into the cluster.
HAproxy is deployed as a Docker container on every slave node in the cluster and
is mapped to port 80 on the host.

In a typical cloud example (e.g. AWS) you would have an ELB in front of that,
balancing between the HAProxy containers and forwarding the traffic to them.

Inside the HAProxy container we have HAProxy and [Consul Template](https://github.com/hashicorp/consul-template)

Consul template drives the HAProxy configuration dynamically from the services registered
in Consul. This means when new services come on and offline, the load balancer configuration
is updated and reloaded dynamically. This allows for zero-touch, zero downtime deployments and
dynamic / auto scaling.

The HAProxy template is stored in the haproxy role [here](../../roles/haproxy/files).

In order to configure the domain haproxy is servicing, the ```haproxy_domain``` variable
may be set. By default it is set to ```example.com```. This should be adjusted
to be set to whatever domain you have registered for your Apollo cluster.
