## DNS in Apollo

We use a combination of [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html)
and Consul to provide DNS for services.

### How it works

When a Docker container starts up it publishes its information (IP address and port)
to the Consul backend via [registrator](https://github.com/gliderlabs/registrator).

The registrator Docker container is running on every slave instance.

When a Docker container is killed or removed, registrator subsequently takes care of removing
the service information from Consul.

By default the name of the service will be equivalent to what it is started up with (using the docker run command). For example docker run --name redis (would publish a service with name 'redis' to Consul).

This can be overridden by providing the ```SERVICE_NAME``` environment variable. Services can also be tagged using the ```SERVICE_TAGS``` environment variable. For more information see the docs on [registrator](https://github.com/gliderlabs/registrator)

A working example -

```docker run -d --name redis.0 -p 6379:6379 dockerfile/redis```

This publishes a service with the name 'redis' to consul and the port of 6379. The IP address that is published to Consul will be the internal IP address of the container running on the weave network.

This service can be resolved through Consul DNS at ```redis.service.consul```.

Dnsmasq is set up to forward any queries for the .consul domain to the consul DNS server. For more information about how consul DNS works see [this doc](https://www.consul.io/docs/agent/dns.html)
