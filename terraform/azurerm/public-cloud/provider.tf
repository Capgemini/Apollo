/* Configure auth 2 resource manager authentication. This requires an aplication to be set up in Azure, see
https://www.terraform.io/docs/providers/azurerm/index.html fo details. */

provider "azurerm" {
	subscription_id = "${var.subscription_id}"
	client_id       = "${var.client_id}"
	client_secret   = "${var.client_secret}"
	tenant_id       = "${var.tenant_id}"
}