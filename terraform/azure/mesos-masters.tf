/* Cloud services for master instances */
resource "azure_hosted_service" "mesos-master" {
  name               = "${var.hosted_service_name.master}-${count.index}"
  count              = "${var.masters}"
  location           = "${var.region}"
  ephemeral_contents = false
  description        = "Mesos master service ${count.index}"
  label              = "mesos_masters"
  provisioner "local-exec" {
    command = "./azure-upload-certificate.sh ${var.hosted_service_name.master}-${count.index}"
  }
}

/* Mesos master instances */
resource "azure_instance" "mesos-master" {
  name                 = "apollo-mesos-master-${count.index}"
  hosted_service_name  = "${element(azure_hosted_service.mesos-master.*.name, count.index)}"
  depends_on           = ["azure_instance.bastion"]
  description          = "mesos_masters"
  count                = "${var.masters}"
  image                = "${var.atlas_artifact.master}"
  size                 = "${var.instance_type.master}"
  storage_service_name = "${azure_storage_service.azure_mesos_storage.name}"
  virtual_network      = "${azure_virtual_network.virtual-network.id}"
  subnet               = "private"
  location             = "${var.region}"
  username             = "${var.username}"
  ssh_key_thumbprint   = "${file("ssh_thumbprint")}"
}
