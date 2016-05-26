### Azure Resource Manager terraform configuration
---------------------------------------------------

This folder contains the terraform configuration for a public and private infrastructure provisioned in Azure and is created by attempting to reverse engineering existing AWS architecture, https://github.com/Capgemini/Apollo/tree/master/terraform/aws.

The configuration is based on Terraform's ARM provider, https://www.terraform.io/docs/providers/azurerm/index.html.
To allow terrafom to create the infrastructure within your Azure subscription the following information is required by the 'provider.tf' file, subscription id, client id, client secret, tenant id. To set up oAuth authentication follow this guide https://www.terraform.io/docs/providers/azurerm/index.html.  

Connection to the server instances is via ssh authenticated by a public / private key certificate in openssh format. I used Putty to generate the public / private key files. There was an issue certificate only authentication **so please use Terraform verion v0.6.16 or higher**.
