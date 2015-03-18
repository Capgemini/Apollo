/* Base packer build we use for provisioning master / slave instances */
resource "atlas_artifact" "mesos" {
  name = "capgemini/mesos-0.21.0_ubuntu-14.04_amd64"
  type = "aws.ami"
}
