variable resource_group_name {}
variable account_location {
  default = "eastus2"
}
variable workspace_location {
  default = "eastus"
}

variable purpose {
  default = "AUM Demo"
}
variable owner_name {}

# Resource group for Automation account and Log Analytics workspaces
resource "azurerm_resource_group" "resource_group" {
    name     = "${var.resource_group_name}"
    location = "eastus"

    tags {
        purpose = "${var.purpose}"
        owner   = "${var.owner_name}"
    }
}

# Automation account for Update Management
resource "azurerm_automation_account" "account" {
  name                = "${azurerm_resource_group.resource_group.name}-account"
  location            = "${var.account_location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"

  sku {
    name = "Basic"
  }
}

# Log Analytics workspace for Update Management
resource "azurerm_log_analytics_workspace" "workspace" {
  name                = "${azurerm_resource_group.resource_group.name}-workspace"
  location            = "${var.workspace_location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  sku                 = "PerGB2018"
  retention_in_days   = 30    
}

# tie the account to the workspace
resource "azurerm_log_analytics_linked_service" "account_to_workspace" {
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  workspace_name      = "${azurerm_log_analytics_workspace.workspace.name}"
  resource_id         = "${azurerm_automation_account.account.id}"
}

# enable the Azure Update Management solution
resource "azurerm_log_analytics_solution" "update_solution" {
  solution_name         = "Updates"
  location              = "${azurerm_resource_group.resource_group.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  workspace_resource_id = "${azurerm_log_analytics_workspace.workspace.id}"
  workspace_name        = "${azurerm_log_analytics_workspace.workspace.name}"

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Updates"
  }
}
