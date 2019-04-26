# Azure Update Management samples

### Terraform Samples
**Terraform/DeployUpdateManagementLab**

This sample deploys the necessary bits to enable Azure Update Management in your subscription. Information on how to configure Terraform to connect to your Azure subscription can be found [here](https://www.terraform.io/docs/providers/azurerm/auth/service_principal_client_secret.html).

This deployment:

 * creates a resource group
 * creates an Automation account within the resource group
 * creates a Log Analytics workspace within the resource group
 * links the account and the workspace
 * enables Update Management in the workspace
 * deploys several Linux VMs and
    * enables the Log Analytics agent on each
    * tags each with a patch_window tag so they will be picked up by a deployment schedule
 * creates weekly patch schedules that run on Saturday and Sunday, targeting Linux VMs with tags _patch_window=saturday_ and _patch_window=sunday_ respectively
 

 To get started, open up a cloud shell in Azure and clone this repository:
>*git clone https://github.com/jomessec/Azure-Update-Management-Samples.git*
>change directories to DepoyUpdateManagementLab
>*terraform init*
>*terrafrom apply*
