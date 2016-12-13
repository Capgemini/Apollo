/* Mesos slave instances */
resource "azure_instance" "mesos-slave" {
  name                 = "apollo-mesos-slave-${count.index}"
  description          = "Mesos slave ${count.index}"
  depends_on           = ["azure_instance.mesos-master"]
  count                = "${var.slaves}"
  /* @todo - replace with variable or atlas artifact */
  image                = "apollo-ubuntu-14.04-amd64-1434963352"
  size                 = "${var.instance_type.slave}"
  security_group       = "${azure_security_group.default.name}"
  location             = "${var.region}"
  username             = "${var.username}"
  ssh_key_thumbprint   = "${var.ssh_key_thumbprint}"
  /*user_data            = "{role: mesos_slaves}"*/

  endpoint {
    name         = "SSH"
    protocol     = "tcp"
    public_port  = 22
    private_port = 22
  }
}
