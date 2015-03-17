terraform-mesos-consul-ceph-weave
=========

#WARNING - THIS IS PURELY EXPERIMENTAL AND NOT TESTED FULLY ON ALL PROVIDERS YET

A repo to test get 3 mesos master and 3 mesos slave on AWS, Rackspace or Google Compute Engine, with Consul keystore, weave, docker, ceph cluster and jenkins running.

# Prereqs
## Basic stuff
- AWS access and secret keys
- [Terraform](http://terraform.io)
- [Terraform Ceph Module] 
First, you should download the module using terraform get
terraform get
Get: git::https://github.com/riywo/mesos-ceph.git


Then, you can check terraform plan. To show resources in module, you have to provide -module-depth option.
```terraform plan -module-depth -1```
The Terraform execution plan has been generated and is shown below.
Resources are shown in alphabetical order for quick scanning. Green resources
will be created (or destroyed and then created if an existing resource
exists), yellow resources are being changed in-place, and red resources
will be destroyed.

- [Consul](http://consul.io)
- ZoneID for Route53

## Things you need to do
- Copy ```terraform.tfvars.example``` to ```terraform.tfvars``` and replace the values (or supply ```-var``` in your command line) 
- Check ```variables.tf``` to ensure you are using the proper AMIs. Right now I have it set to Ubuntu Trusty (14.04) with an instance backed store.
- mesos-master.tf has Availability Zones set to eu-ams-1a, b and c. Please change to meet your needs.

- For this example, we use the Consul cluster to both read configuration and store information about a newly created EC2 instance. The size of the EC2 instance will be determined by the "tf_test/size" key in Consul, and will default to "m1.small" if that key does not exist. Once the instance is created the "tf_test/id" and "tf_test/public_dns" keys will be set with the computed values for the instance.
Before we run the example, use the Web UI to set the "tf_test/size" key to "t1.micro". Once that is done, copy the configuration into a configuration file ("consul.tf" works fine). Either provide the AWS credentials as a default value in the configuration or invoke apply with the appropriate variables set.
Once the apply has completed, we can see the keys in Consul by visiting the Web UI. We can see that the "tf_test/id" and "tf_test/public_dns" values have been set.


## Summary

This Terraform module will spin up instances like below by default:

- admin
    - t2.micro
    - ssh gateway
    - run ceph-deploy
- master1, master2, master3
    - t2.micro
    - mesos master
    - marathon
    - ceph mon
    - ceph mds
    - mount cephfs
- slaves (default 3)
    - t2.micro
    - mesos slave
    - ceph osd
        - 1 EBS attached (default 30GB)
    - mount cephfs

## Fire it up
The default will launch an m3.medium since this is the smallest instace that uses an instance back store. 
```
cd aws
terraform apply 
OR 
cd rackspace
terraform apply
```

# Helpful commands
- Show info about the instances
```terraform show terraform.tfstate```
- Test your terraform config
```terraform plan```
- Delete everything
```
terraform plan -destroy -out=terraform.tfplan
terraform apply terraform.tfplan
```

# Next steps
- Packer template for AWS, Rackspace & GCE
- Consul based backend
- Integrate weave
- Ceph Cluster
- Setup Jenkins on Slave
- Setup ASG, launch configuration and user-data for mesos-slave
- Add the AZs as a variable
- Security groups for AWS and Rackspace
- Move to Ansible playbook for install

# Thanks and Contributions
- https://github.com/riywo/mesos-ceph
- https://github.com/tonyjchong/terraform-mesos
- https://github.com/hashicorp/terraform/tree/master/examples/consul
- https://github.com/hashicorp/consul/blob/master/terraform/
- https://github.com/hashicorp/consul/blob/master/terraform/aws/scripts/upstart-join.conf