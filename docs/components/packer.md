## Packer

We use [Packer](https://packer.io/) to create the base level machine images for Vagrant / AWS / Digitalocean etc...

This allows us to package a base image which comes pre-baked with the software required to run the Apollo cluster.

The basic principle we have followed is:

- Anything that needs to be downloaded and installed from the internet for the base components of the cluster goes into the Packer template.
- We then instantiate these templates and provision them into the cloud. Any config for the environment would be provisioned on the fly by [Terraform](http://terraform.io)

This clear distinction is similar to the [12 factor app principle](http://12factor.net/)

For more info on the project Packer templates see [here](../../packer)

Additional benefits of using Packer include integration with [Atlas](atlas.hashicorp.com) for use as a build tool to build the Packer AMI for Amazon inside the Atlas cloud.

Going forward we will likely try and abstract more of the system out to Docker containers
so that we can run as close to possible off stock operating system images (e.g. just fall
back to the base images/droplets/AMIs provided by each cloud provider and not rely on Packer as much).
