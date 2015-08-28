vpc_cidr_block             = "10.0.0.0/16"
public_subnet_cidr_block   = "10.0.2.0/26"
private_subnet_cidr_blocks = "10.0.4.0/22,10.0.8.0/22,10.0.12.0/22"

atlas_artifact.master = "udacity/mesos-ubuntu-14.04-amd64"
atlas_artifact.slave  = "udacity/mesos-ubuntu-14.04-amd64"

ssl_certificate_arn = "arn:aws:iam::434162760768:server-certificate/star-udacity-com-expires-2016-04-29"

