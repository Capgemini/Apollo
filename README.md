Apollo
======
[![Join the chat at https://gitter.im/Capgemini/Apollo](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Capgemini/Apollo?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![wercker status](https://app.wercker.com/status/71503ff3fde8b162b72e2cc094f52679/s/master "wercker status")](https://app.wercker.com/project/bykey/71503ff3fde8b162b72e2cc094f52679)
[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)


Apollo is an open source project to aid with building and deploying IAAS and
PAAS services. It is particularly geared towards managing containerized applications
across multiple hosts, and big data type workloads. Apollo leverages other
open source components to provide basic mechanisms for deployment, maintenance,
and scaling of infrastructure and applications.

![Apollo](https://cloud.githubusercontent.com/assets/1230698/10170455/df48a3d8-66cc-11e5-8b22-669289975f78.png)

Apollo is built on top of the following components:

* [Terraform](https://www.terraform.io/) for provisioning the infrastructure
* [Apache Mesos](http://mesos.apache.org/) for cluster management, scheduling and resource isolation
* [Consul](http://consul.io) for service discovery, DNS
* [Docker](http://docker.io) for application container runtimes
* [Weave](https://github.com/weaveworks/weave) for networking of docker containers
* [Traefik](http://traefik.github.io) for application container load balancing

Apollo is:

* **highly-available**: multi-datacenter
* **fault-tolerant**: Mesos / Consul master quorum with data replication
* **portable**: public, private, hybrid, multi cloud

Apollo Use Cases:

* Build your own PAAS
* Large scale CI (using the Jenkins Mesos framework)
* Docker container management and orchestration (Marathon framework, Kubernetes)
* Hadoop / Big data platform (Storm framework + others)

For available Mesos frameworks see [https://docs.mesosphere.com/frameworks/](https://docs.mesosphere.com/frameworks/). If you get one of these working on Apollo, please do contribute the setup
back!

Apollo can run anywhere!

However, the majority of initial development is happening on AWS so most of our instructions and scripts are built around that. Stayed tuned for more cloud provider support! If you make it work on other infrastructure please let us know and contribute instructions/code. For more info on cloud
support see our [roadmap](docs/roadmap.md).

Apollo is in beta!

While the concepts and base architectural components of Apollo are not expected to change drastically, the project is still under heavy development. Expect bugs, design and feature changes as we bring it to a stable, production ready, multi-cloud available thing!

## Architecture

![architecture](docs/architecture.png)

The above architecture is representative of Apollo cluster on AWS VPC.

## Documentation
 - **Getting Started Guides**
    - for people who want to create an Apollo cluster
    - in [docs/getting-started-guides](docs/getting-started-guides)
 - **Demonstrators and Examples**
    - [Drupal/MySQL on Marathon](examples/drupal-mysql)
    - [Spring boot on Marathon](examples/spring-boot)
    - [Simple nodeJS REST API on Marathon](examples/nodejs-rest-api)
 - **[Roadmap](docs/roadmap.md)**
 - **Components**
    - for people who want to know more about the individual components and the
    decisions behind selecting them
    - in [docs/components](docs/components)

## Contributing

If you're interested in helping out we've [tagged issues specifically for new contributors](https://github.com/Capgemini/Apollo/labels/new%20contributor)
to help you get familiar with the codebase.

If you need any help/mentoring be sure to drop by our [Gitter channel](https://gitter.im/Capgemini/Apollo?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)!

## Keep up to date...

Check out the [Capgemini UK Engineering blog](http://capgemini.github.io/) to find out more about how Apollo works and its new features.

* [Continuously Deploying Apollo](http://capgemini.github.io/open%20source/continuously-deploying-apollo)
* [How Apollo uses weave](http://capgemini.github.io/devops/how-apollo-uses-weave)
* [Demo: Launching Apollo on aws](http://capgemini.github.io/devops/apollo-launch-aws)
