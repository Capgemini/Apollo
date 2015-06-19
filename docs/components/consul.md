## Consul

Consul is used for service discovery of nodes and services in the cluster.

It has a number of key features -

- Key / value storage
- HTTP REST API
- DNS API
- Highly available / fault tolerant out of the box
- Health checks
- Multi-datacenter support out of the box

For a comparison of Consul against other service discovery backends see [https://www.consul.io/intro/vs/zookeeper.html](https://www.consul.io/intro/vs/zookeeper.html)

The main reasons for selecting Consul over the others are -

- DNS API providing lightweight integration with other tools / services
- Easy integration with Docker via the registrator container. See [https://github.com/gliderlabs/registrator](https://github.com/gliderlabs/registrator)
- Easy integration with Weave. For more info about weave see [weave](weave.md)
- Rich key/value storage for use with Docker containers / services

For more information on how service discovery via DNS works in Apollo see [DNS](../../docs/dns.md).

For more information on Consul see [http://www.consul.io](http://www.consul.io)
or [https://github.com/hashicorp/consul](https://github.com/hashicorp/consul).
