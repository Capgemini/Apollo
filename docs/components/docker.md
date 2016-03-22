## Docker

Docker is used as an application container runtime. The main usage is for running
containers (as a task) on top of Mesos via a Mesos framework.

For example the [Marathon](https://github.com/mesosphere/marathon)
and [Kubernetes](http://kubernetes.io) can both utilise Docker to deploy,
manage and run containers.

For more information on Docker see [https://www.docker.com](https://www.docker.com)

Docker allows a clear separation between the application/task
and the underlying operating system. As such this gives developers full flexibility
about what they choose to run on top of Apollo.

We use Docker in combination with [Weave](weave.md), with weave providing the virtual
networking layer which makes accessing Docker containers across multiple hosts simpler.
