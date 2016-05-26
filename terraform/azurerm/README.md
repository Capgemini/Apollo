### Azure Resource Manager terraform configuration
---------------------------------------------------

This folder contains the terraform configuration for a public and private infrastructure provisioned in Azure and is created by reverse engineering existing AWS architecture, https://github.com/Capgemini/Apollo/tree/master/terraform/aws.

The configuration is based on Terraform's Azure Resource Manager provider, https://www.terraform.io/docs/providers/azurerm/index.html.
To allow terrafom to create the infrastructure within Azure the following information is require by the 'provider.tf' file, subscription id, client id, client secret, tenant id. To set up oAuth authentication in your Azure subscription follow this guide https://www.terraform.io/docs/providers/azurerm/index.html.  
