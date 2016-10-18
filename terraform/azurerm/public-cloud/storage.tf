# Create a storage account
resource "azurerm_storage_account" "storage_account" {
	name = "${var.storage_account_name}"
	resource_group_name = "${azurerm_resource_group.resource_group.name}"
	location = "${var.region}"
	account_type = "${var.storage_account_type}"
}

# Create storage container
resource "azurerm_storage_container" "storage_container" {
	name = "${var.storage_container_name}"
	resource_group_name = "${azurerm_resource_group.resource_group.name}"
	storage_account_name = "${azurerm_storage_account.storage_account.name}"
	container_access_type = "private"
	depends_on = ["azurerm_storage_account.storage_account"]
}

# Storage Account Output
output "storage_account_id" {
	value = "${azurerm_storage_account.storage_account.id}"
}

output "storage_account_primary_location" {
	value = "${azurerm_storage_account.storage_account.primary_location}"
}

output "storage_account_secondary_location" {
	value = "${azurerm_storage_account.storage_account.secondary_location}"
}

output "storage_account_primary_blob_endpoint" {
	value = "${azurerm_storage_account.storage_account.primary_blob_endpoint}"
}

output "storage_account_secondary_blob_endpoint" {
	value = "${azurerm_storage_account.storage_account.secondary_blob_endpoint}"
}

output "storage_account_primary_queue_endpoint" {
	value = "${azurerm_storage_account.storage_account.primary_queue_endpoint}"
}

output "storage_account_secondary_queue_endpoint" {
	value = "${azurerm_storage_account.storage_account.secondary_queue_endpoint}"
}

output "storage_account_primary_table_endpoint" {
	value = "${azurerm_storage_account.storage_account.primary_table_endpoint}"
}

output "storage_account_secondary_table_endpoint" {
	value = "${azurerm_storage_account.storage_account.secondary_table_endpoint}"
}

output "storage_account_primary_file_endpoint" {
	value = "${azurerm_storage_account.storage_account.primary_file_endpoint}"
}

# Storage Container Output
output "storage_container_id" {
	value = "${azurerm_storage_container.storage_container.id}"
}

output "storage_container_properties" {
	value = "${azurerm_storage_container.storage_container.properties}"
}
