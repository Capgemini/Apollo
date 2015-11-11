## Networking in Apollo

### Overview

Apollo's networking is slightly different to the Docker default networking.
Each Docker container will receive its own IP address allocated from an internal network.

There is no need to explicitly create links between containers, or use Docker host > container port mapping to communicate between the containers.

We use [weave](components/weave.md) to enable the communication between containers.

The setup is heavily inspired from this article [http://sttts.github.io/docker/weave/mesos/2015/01/22/weave.html](http://sttts.github.io/docker/weave/mesos/2015/01/22/weave.html)

Since containers can fail and be restarted / replaced by Mesos (and land on different IP addresses)
it is not recommended to have containers talk to each other explicitly via the IP address. Instead it is recommended to use the Consul DNS address of the service you wish to talk to. For an overview of how DNS works read the [dns](dns.md)

### Docker networking

For a complete guide to the default Docker networking see the [docker networking guide](https://docs.docker.com/articles/networking/).

The below (about Docker networking) is shamelessly stolen from [https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/networking.md](https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/networking.md) (Thanks Google!)

By default, Docker uses host-private networking. It creates a virtual bridge, called docker0 by default, and allocates a subnet from one of the private address blocks defined in RFC1918 for that bridge. For each container that Docker creates, it allocates a virtual ethernet device (called veth) which is attached to the bridge. The veth is mapped to appear as eth0 in the container, using Linux namespaces. The in-container eth0 interface is given an IP address from the bridge's address range.

The result is that Docker containers can talk to other containers only if they are on the same machine (and thus the same virtual bridge). Containers on different machines can not reach each other - in fact they may end up with the exact same network ranges and IP addresses.

In order for Docker containers to communicate across nodes, they must be allocated ports on the machine's own IP address, which are then forwarded or proxied to the containers. This obviously means that containers must either coordinate which ports they use very carefully or else be allocated ports dynamically.

### Apollo networking

Since co-ordinating forwarded ports and statically linking containers to each other is quite cumbersome we use Weave to get around that. This means -

* All containers can communicate with other containers via the container IP address and
port inside the Weave network
* All nodes can communicate with containers via the container IP address and
port inside the Weave network
* We use HAProxy to co-ordinate routing 'external traffic' from the internet to the correct container or group of containers. HAproxy will sit inside the Weave network (so is able to communicate with all containers) and listen on port 80 for web traffic, any incoming requests on port 80 it will redirect to the specific service.

To achieve this we do the following -

We start Docker with:

```
DOCKER_OPTS="--bridge=weave --fixed-cidr={{ weave_docker_subnet }}
```

We set up the Weave bridge on each slave instance with:

```
auto weave
iface weave inet manual
  pre-up /usr/local/bin/weave create-bridge
  post-up ip addr add dev weave {{ weave_bridge }}
  pre-down ifconfig weave down
  post-down brctl delbr weave
```

weave_bridge is by default set to 10.2.0.1/16.

The weave_docker_subnet is different for each host in the Weave network. For example
on HOST1 the weave docker subnet would be ```10.2.1.0/24``` but on HOST2 it would be
```10.2.2.0/24```, and so on. This is to ensure that containers started on HOST1 do not clash IP
addresses with containers started on HOST2. This gives the ability for up to 256 containers per host.

As an example, if a container was started on HOST1 its IP address might be 10.2.1.1.

See the [weave ansible role](../roles/weave) for more information.
