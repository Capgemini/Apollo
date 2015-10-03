/*
  You need to download the setting file from
  https://manage.windowsazure.com/publishsettings and set env variable
  TF_VAR_azure_settings_file pointing to the file.
*/
provider "azure" {
  settings_file = "${file(var.azure_settings_file)}"
}
