variable vm_count {
    default =   3
}
variable vm_location {
  default = "eastus"
}

variable vm_password {
    default = "This is a Passw0rd."
}

variable linux_vms_root_name {}
#variable windows_vms_root_name {}

module "deployLinuxVMs" {
    source              = "/modules/deployLinuxVMs"
    vm_count            = "${var.vm_count}"
    vm_password         = "${var.vm_password}"
    vm_name             = "${var.linux_vms_root_name}"
    vm_location         = "${var.vm_location}"
    vm_resource_group   = "${azurerm_resource_group.resource_group.name}"
    vm_nsg_id           = "${azurerm_network_security_group.nsg.id}"
    vm_subnet_id        = "${azurerm_subnet.subnet.id}"
    workspace_id        = "${azurerm_log_analytics_workspace.workspace.workspace_id}"
    workspace_key       = "${azurerm_log_analytics_workspace.workspace.primary_shared_key}"
   
}

/*
module "deployWindowsVMs" {
    source              = "/modules/deployWindowsVMs"
    vm_count            = "${var.vm_count}"
    vm_name             = "${var.linux_vms_root_name}"
    vm_location         = "${var.vm_location}"
    vm_resource_group   = "${azurerm_resource_group.resource_group.name}"
    vm_nsg_id           = "${azurerm_network_security_group.nsg.id}"
    vm_subnet_id        = "${azurerm_subnet.subnet.id}"
    workspace_id        = "${azurerm_log_analytics_workspace.workspace.workspace_id}"
    workspace_key       = "${azurerm_log_analytics_workspace.workspace.primary_shared_key}"
   
}
*/