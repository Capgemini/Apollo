## Atlas

We use [Atlas](https://atlas.hashicorp.com) as a centralised storage point for artifacts across cloud providers (and for the Vagrant box).

Since only AWS supports public images (AMIs) we have made the AWS artifact available publicly.

Digitalocean only support private images and the ability to share images privately. There is some discussion around public images at this thread [https://digitalocean.uservoice.com/forums/136585-digitalocean/suggestions/3249642-share-an-image-w-another-account](https://digitalocean.uservoice.com/forums/136585-digitalocean/suggestions/3249642-share-an-image-w-another-account).

On Google cloud the only public images available are maintained by Google. They follow a similar approach to Digitalocean. You can read about their policy here [https://cloud.google.com/compute/docs/images#public_images](https://cloud.google.com/compute/docs/images#public_images).

### Creating your own artifacts in Atlas

If you want to build your own Atlas artifacts for use on Digitalocean(required) then you will need to build and push the artifact yourself in the Atlas cloud.

This is so the artifact is associated with your Digitalocean / Atlas account.

To build the Digitalocean image in atlas do the following:

1. Edit ```packer/ubuntu-14.04_amd64-droplet.json``` to reference your organisation in
the push and post-processor config. At the moment there is a bug in packer which does not allow us to do variable interpolation in push config, see [https://github.com/mitchellh/packer/issues/1861](https://github.com/mitchellh/packer/issues/1861)

```
cd packer/
packer push -token=$ATLAS_TOKEN -create ubuntu-14.04_amd64-droplet.json
```
or:
```
packer push -token=$ATLAS_TOKEN -m="Optional message here" ubuntu-14.04_amd64-droplet.json
```

replacing $ATLAS_TOKEN with your Atlas API token.

This should create a build configuration under -

https://atlas.hashicorp.com/YOUR_OGRANISATION/build-configurations/apollo-ubuntu-14-04-amd64

The build will probably fail first time, this will be due to Atlas not having your API token. You will need to add the DIGITALOCEAN_API_TOKEN as a variable under https://atlas.hashicorp.com/YOUR_ORGANISATION/build-configurations/apollo-ubuntu-14-04-amd64/variables.

Once your build is completed there should be a new artifact under https://atlas.hashicorp.com/YOUR_ORGANISATION/artifacts/apollo-ubuntu-14.04-amd64

The same steps apply if you want to create your own build configuration / artifacts for AWS/Google.
