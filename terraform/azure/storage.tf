resource "azure_storage_service" "azure_mesos_storage" {
  name = "${var.storage_name}"
  location = "${var.region}"
  description = "Made by Terraform."
  account_type = "Standard_GRS"
}
