# Azure Update Management samples

## Deploy an Azure Update Management environment with Terraform Samples
**Terraform/DeployUpdateManagementLab**

This deploys an Azure Update Management Hands-On Lab (HOL)  into a resource group in your subscription. 

This deployment:

 * creates a resource group
 * creates an Automation account within the resource group
 * creates a Log Analytics workspace within the resource group
 * links the account and the workspace
 * enables Update Management in the workspace
 * enables Change Tracking and Inventory in the workspace
 * deploys several Linux VMs and
    * enables the Log Analytics agent on each
    * tags each with a patch_window tag so they will be picked up by a deployment schedule
 * creates weekly patch schedules that run on Saturday and Sunday, targeting Linux VMs with tags _patch_window=saturday_ and _patch_window=sunday_ respectively
 
### Getting Started

#### One-Time Setup
 To get started, open up a cloud shell in Azure and clone this repository:
* *git clone https://github.com/jomessec/Azure-Update-Management-Samples.git*
* change directories to Terraform/DepoyUpdateManagementLab in the repository
* set up client secrets as described [here](https://www.terraform.io/docs/providers/azurerm/auth/service_principal_client_secret.html)
   * find the subscription you want to deploy to from *az account list*
   * create a service principal to use for deployments
      * *az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTIONID"*
   * create a file azureSecrets.tfvars and put the following rows in it, replacing the values from the previous steps:
      * subscription_id = "SUBSCRIPTIONID"
      * client_secret       = "PASSWORD"
      * client_id           = "APPID"
      * tenant_id           = "TENANT"

* *terraform init*

#### Deploying The lab
* now we're ready to deploy the lab:
   * *terrafrom apply*
   * Follow the prompt for resource group and VM root name. By default 3 VMs will be created from the root name, but this can be changed by passing in variable names.
   * Alternatively you can pass the variables on the command line:
      * *terraform apply -var "linux_vms_root_name=MyServer" -var "resource_group_name=MyResourceGroup"*
