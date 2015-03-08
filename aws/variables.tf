variable "access_key" {}
variable "secret_key" {}
variable "key_name" {}
variable "key_file" {}
variable "zone_id" {}
variable "mesos_dns" {}

# Official Ubuntu Cloud Images
# https://cloud-images.ubuntu.com/trusty/current/

variable "amis" {
    default = {
        us-east-1 = "ami-9415a7fc"
        us-west-2 = "ami-65753855"
        us-west-1 = "ami-1948425c"
    }
}

variable "region" {
    description = "The AWS region to create resources in."
    default = "us-east-1"
}