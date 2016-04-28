# Create a resource group
resource "azurerm_resource_group" "resource_group" {
    name     = "AzureRM-Resource-Group"
    location = "${var.region}"
}