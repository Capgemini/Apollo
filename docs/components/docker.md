## Docker

Docker is used as an application container runtime. The main usage is for running
containers (as a task) on top of Mesos via a Mesos framework.

For accessing private registries make sure you export the next environment variables before deploying Apollo:
* APOLLO_docker_registry_mail
* APOLLO_docker_registry_pass
* APOLLO_docker_registry_user

Your credentials would be available for marathon via:
```
  "uris": [
    "http://your-marathon-url:8080/v2/artifacts/docker.tar.gz"
  ],
```

or:

```
"uris": [
  "file:///tmp/mesos/docker.tar.gz"
],
```

For example the [Marathon](https://github.com/mesosphere/marathon)
and [Kubernetes](http://kubernetes.io) can both utilise Docker to deploy,
manage and run containers.

For more information on Docker see [https://www.docker.com](https://www.docker.com)

The reason behind choosing Docker is it allows clear separation between the application/task
and the underlying operating system. As such this gives developers full flexibility
about what they choose to run on top of Apollo.

We use Docker in combination with [Weave](weave.md), with weave providing the virtual
networking layer which makes accessing Docker containers across multiple hosts simpler.
