## Getting started on Microsoft Azure

settings file -

https://manage.windowsazure.com/publishsettings

Create SSH Key thumbprint -

https://azure.microsoft.com/en-gb/documentation/articles/virtual-machines-linux-use-ssh-key/

Upload SSH cert -

https://manage.windowsazure.com/#Workspaces/AdminTasks/ListManagementCertificates

Create a storage account -

https://manage.windowsazure.com/#Workspaces/StorageExtension

I named it capgeminiapollo

Create a storage container -

https://manage.windowsazure.com/#Workspaces/StorageExtension/StorageAccount/capgeminiapollo/Containers

Use the storage account name from above here and named the storage container 'images'.

Packer build -

Follow the instructions here https://github.com/msopentech/packer-azure to build the compile
the packer plugin for Azure via Go and copy it to your packer install folder (normally
/usr/local/packer/) and then -

packer build -var 'azure_settings_file=azure.publishsettings' -var 'azure_subscription_name=Free Trial' -var 'azure_storage_account=capgeminiapollo' -var 'azure_storage_container=images' -var 'azure_location=North Europe' -var 'azure_source_image=Ubuntu Server 14.04 LTS' -var 'azure_instance_type=Small' -var 'version=1.0.0' ubuntu-14.04_amd64-azure.json
