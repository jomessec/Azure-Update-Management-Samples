# load the json template for linux update deployment
data "template_file" "update_deployment_json" {
  template = "${file("${path.module}/templates/linuxUpdateDeployment.json")}"
  vars = {}
}


# create a schedule that runs every Saturday, targeting onboarded VMs tagged with patch_window=Saturday
resource "azurerm_template_deployment" "saturday_schedule" {
  name                = "update_deployment_schedule_saturday_linux"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  template_body       = "${data.template_file.update_deployment_json.rendered}"
  deployment_mode     = "Incremental"
  # these key-value pairs are passed into the ARM Template's `parameters` block
  parameters = {
    "location"                      = "${azurerm_resource_group.resource_group.location}"
    "automationAccountName"         = "${azurerm_automation_account.account.name}"
    "updateManagementScheduleName"  = "saturday_patch_window"
    "updateManagementScheduleDay"   = "Saturday"
    "startDate"                     = "${timeadd(timestamp(), "1h")}"
    "scope"                         = "${azurerm_resource_group.resource_group.id}"
  }
}

# create a schedule that runs every Sunday, targeting onboarded VMs tagged with patch_window=Sunday
resource "azurerm_template_deployment" "sunday_schedule" {
  name                = "update_deployment_schedule_sunday_linux"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  template_body       = "${data.template_file.update_deployment_json.rendered}"
  deployment_mode     = "Incremental"
  # these key-value pairs are passed into the ARM Template's `parameters` block
  parameters = {
    "location"                      = "${azurerm_resource_group.resource_group.location}"
    "automationAccountName"         = "${azurerm_automation_account.account.name}"
    "updateManagementScheduleName"  = "sunday_patch_window"
    "updateManagementScheduleDay"   = "Sunday"
    "startDate"                     = "${timeadd(timestamp(), "1h")}"
    "scope"                         = "${azurerm_resource_group.resource_group.id}"
  }
}
