## Apache Mesos

[Apache Mesos](http://mesos.apache.org/) is used for cluster management, orchestration and resource scheduling.

The main reason behind choosing it is detailed on their website -

> "Apache Mesos abstracts CPU, memory, storage, and other compute resources away from machines (physical or virtual), enabling fault-tolerant and elastic distributed systems to easily be built and run effectively."

Other reasons to select it include -

* Non opinionated in what type of framework / what is run on top of it. This means any type of framework can be built on Mesos which uses the underlying resource and scheduling APIs
* Frameworks can be written in any language, and their are language bindings for Go, Python, Scala, C++ and Java
* Fault tolerant out of the box (via replicated master/slaves using Zookeeper)
* Scalable out of the box
* Simplify's the view of the datacenter treating a cluster of machines, like looking down at one big machine.
* Large number of frameworks already existing, suiting different use cases. See [http://mesos.apache.org/documentation/latest/mesos-frameworks/](http://mesos.apache.org/documentation/latest/mesos-frameworks/) for a list of frameworks.
* Used in production by a number of large companies including Apple, Twitter, AirBnB
