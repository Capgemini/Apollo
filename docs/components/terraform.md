## Terraform

We use [Terraform](https://www.terraform.io/) as an infrastructure provisioning tool. This allows us to declare the state of our infrastructure against various [cloud providers](https://www.terraform.io/docs/providers/index.html).

The general flow is (for example for Amazon) -

- Run a terraform plan to provision the necessary instances in AWS corresponding to the architecture we have chosen (e.g. public cloud / private VPC)
- Run Ansible on top of those instances to configure them on the fly and start up the necessary services to bring an Apollo cluster up.
