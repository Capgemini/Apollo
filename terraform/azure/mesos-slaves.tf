/* Cloud services for slave instances */
resource "azure_hosted_service" "mesos-slave" {
  name               = "${var.hosted_service_name.slave}-${count.index}"
  count              = "${var.slaves}"
  location           = "${var.region}"
  ephemeral_contents = false
  description        = "Mesos slave service ${count.index}"
  label              = "mesos_slaves"
  provisioner "local-exec" {
    command = "./azure-upload-certificate.sh ${var.hosted_service_name.slave}-${count.index}"
  }
}

/* Mesos slave instances */
resource "azure_instance" "mesos-slave" {
  name                 = "apollo-mesos-slave-${count.index}"
  hosted_service_name  = "${element(azure_hosted_service.mesos-slave.*.name, count.index)}"
  depends_on           = ["azure_instance.bastion", "azure_instance.mesos-master"]
  description          = "mesos_slaves"
  count                = "${var.slaves}"
  image                = "${var.atlas_artifact.slave}"
  size                 = "${var.instance_type.slave}"
  storage_service_name = "${azure_storage_service.azure_mesos_storage.name}"
  virtual_network      = "${azure_virtual_network.virtual-network.id}"
  subnet               = "private"
  location             = "${var.region}"
  username             = "${var.username}"
  ssh_key_thumbprint   = "${file("ssh_thumbprint")}"
}
