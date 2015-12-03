vpc_cidr_block             = "10.0.0.0/16"
public_subnet_cidr_blocks  = "10.0.2.0/26,10.0.2.64/26,10.0.2.128/26,10.0.2.192/26"
private_subnet_cidr_blocks = "10.0.4.0/24,10.0.5.0/24,10.0.6.0/24,10.0.7.0/24"

atlas_artifact.master = "udacity/mesos-ubuntu-14.04-amd64"
atlas_artifact.slave  = "udacity/mesos-ubuntu-14.04-amd64"

ssl_certificate_arn = "arn:aws:iam::434162760768:server-certificate/star-udacity-com-expires-2016-04-29"

slave_block_device.volume_size = 60
