/* Mesos master instances */
resource "azure_instance" "mesos-master" {
  name                 = "apollo-mesos-master-${count.index}"
  description          = "Mesos master ${count.index}"
  count                = "${var.masters}"
  /* @todo - replace with variable */
  image                = "apollo-ubuntu-14.04-amd64-1434963352"
  size                 = "${var.instance_type.master}"
  security_group       = "${azure_security_group.default.name}"
  location             = "${var.region}"
  username             = "${var.username}"
  ssh_key_thumbprint   = "${var.ssh_key_thumbprint}"
  /*user_data            = "{role: mesos_masters}"*/

  endpoint {
    name         = "SSH"
    protocol     = "tcp"
    public_port  = 22
    private_port = 22
  }
}
