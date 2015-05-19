## Packer

[Packer](https://packer.io/) is used to automate the build for the base image which is used to provision everywhere.

This automation includes:

- installing some base level packages and config
- installing Mesos
- installing Consul
- installing Weave
- installing dnsmasq

At the moment we have packer images for the following:

- Vagrant
- Google Compute Engine
- Digitalocean
- Amazon AMI

### Building the packer images

#### Vagrant

To build the Vagrant image:

Firstly, you will need to set the following envinronment variables

```
ATLAS_TOKEN
```

Only if you plan on using the vagrant cloud post processor to upload the box to Atlas.

If you don't want to upload to Atlas you can remove the following block:

```
{
  "type": "vagrant-cloud",
  "box_tag": "capgemini/apollo",
  "access_token": "{{user `access_token`}}",
  "version": "{{user `version`}}"
}
```

To build the box:

```
packer build ubuntu-14.04_amd64.json
```

#### AWS

To build the AWS AMI:

Export the following environment variables -

```
AWS_ACCESS_KEY_ID (ID for your AWS secret key)
AWS_ACCESS_KEY (AWS secret key)
AWS_REGION (the region to build the AMI in, e.g. eu-west-1)
AWS_SOURCE_AMI (the source AMI to build the image off, e.g. ami-394ecc4e)
AWS_INSTANCE_TYPE (the instance type to use to build the image, e.g. m1.medium)
```

To build the box:

```
packer build ubuntu-14.04_amd64-amis.json
```

For a complete configuration reference see [https://packer.io/docs/builders/amazon-ebs.html](https://packer.io/docs/builders/amazon-ebs.html)

#### Digitalocean

To build the Digitalocean image:

Export the following environment variables:

```
DIGITALOCEAN_API_TOKEN (a v2 API token)
DIGITALOCEAN_REGION (the region to build the image in, e.g. lon1)
DIGITALOCEAN_SIZE (the size of image to use when building, e.g. 512mb)
DIGITALOCEAN_IMAGE (the base image to use to build off, e.g. ubuntu-14-04-x64)
```

To build the box:

```
packer build ubuntu-14.04_amd64-droplet.json
```
For a complete configuration reference see [https://packer.io/docs/builders/digitalocean.html](https://packer.io/docs/builders/digitalocean.html)

#### Google Compute Engine

To build the GCE image:

Export the following environment variables:

```
GCS_ACCOUNT_FILE (the JSON file containing your account credentials)
GCS_PROJECT_ID (the project ID that will be used to launch the instance)
GCS_SOURCE_IMAGE (the source image to build the image from, e.g. ubuntu-1404-trusty-v20150316)
GCS_ZONE (the zone to build the image in, e.g. europe-west1-b)
```

For a complete configuration reference see [https://packer.io/docs/builders/googlecompute.html](https://packer.io/docs/builders/googlecompute.html)
