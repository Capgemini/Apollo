## DNS in Apollo

We use a combination of [mesos-consul](https://github.com/CiscoCloud/mesos-consul)
and Consul to provide DNS for services/tasks that are started via Mesos/Marathon.

### How it works

When a Mesos task starts up it publishes its information (IP address and port)
to the Consul backend via [mesos-consul](https://github.com/CiscoCloud/mesos-consul).

The mesos_consul Docker container is running on every master instance and is subscribing to changes
via the Mesos API.

When a Mesos task is killed or removed, mesos-consul subsequently takes care of removing
the service registry information from Consul.

By default the name of the service will be equivalent to what it is started up via marathon (at appname.service.consul).
