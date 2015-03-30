Apollo
=========

[![wercker
status](https://app.wercker.com/status/71503ff3fde8b162b72e2cc094f52679/m/master
"wercker
status")](https://app.wercker.com/project/bykey/71503ff3fde8b162b72e2cc094f52679)

Apollo is an open source project to aid with building and deploying IAAS and
PAAS services. It is particularly geared towards managing containerized applications
across multiple hosts, and hooks into other open source products to provide basic
mehanisms for deployment, maintenance, and scaling of infrastructure and applications.

Apollo is built on top of the following components:

* [Packer](https://packer.io)
* [Terraform](https://www.terraform.io/)
* [Apache Mesos](http://mesos.apache.org/)
* [Consul](http://consul.io)
* [Docker](http://docker.io)
* [Weave](https://github.com/zettio/weave)

Apollo is:

* **self-healing**: auto-placement, auto-restart, auto-replication
* **portable**: public, private, hybrid, multi cloud

Apollo can run anywhere!

However, initial development is happening on AWS so our instructions and scripts are built around that. Stayed tuned for more cloud provider support! If you make it work on other infrastructure please let us know and contribute instructions/code.

Apollo is in alpha!

While the concepts and base architectural components of Apollo are not expected to change drastically, the project is still under heavy development. Expect bugs, design and API changes as we bring it to a stable, production ready, multi-cloud available product.

## Documentation
 - **Getting Started Guides**
    - for people who want to create an Apollo cluster
    - in [docs/getting-started-guides](docs/getting-started-guides)
