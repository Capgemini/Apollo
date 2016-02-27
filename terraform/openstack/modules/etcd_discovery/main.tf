# Variables

variable "mesos_masters"           { default = "3" }
variable "mesos_slaves"            { default = "1"}
variable "etcd_discovery_url_file" { default = "etcd_discovery_url.txt"}

## The null resource allows for executing provisioners that are decoupled from existing resources to allow for better module flexibility.

resource "null_resource" "etcd_discovery" {
  # Changes to the specified variables will trigger the provisioner again
  triggers {
    mesos_masters = "${var.mesos_masters}"
    mesos_slaves  = "${var.mesos_slaves}"
  }

  provisioner "local-exec" {
    command = "curl https://discovery.etcd.io/new?size=${var.mesos_masters + var.mesos_slaves} > ${var.etcd_discovery_url_file}"
  }
}

# This won't work unfortunately
# output "etcd_discovery_url" { value = "${file(var.etcd_discovery_url_file)}" }
output "executed_check" { value = "${null_resource.etcd_discovery.id}" }