variable vm_name {}
variable vm_count {
}
variable vm_location {}
variable vm_resource_group {}
variable workspace_id {}
variable workspace_key{}
variable vm_nsg_id {}
variable vm_subnet_id {}
variable vm_password {
}
variable vm_patch_window_tag_value {
    default = "sunday"
}

#create a public IP address for the VM
resource "azurerm_public_ip" "ip" {
    count                       = "${var.vm_count}"
    name                        = "${var.vm_name}${count.index}-ip"
    location                    = "${var.vm_location}"
    resource_group_name         = "${var.vm_resource_group}"
    allocation_method           = "Dynamic"
}

# create a vnic for the VM
resource "azurerm_network_interface" "nic" {
    count                       = "${var.vm_count}"
    name                        = "${var.vm_name}${count.index}-nic"
    location                    = "${var.vm_location}"
    resource_group_name         = "${var.vm_resource_group}"
    network_security_group_id   = "${var.vm_nsg_id}"

    ip_configuration {
        name                          = "${var.vm_name}${count.index}-ip-config"
        subnet_id                     = "${var.vm_subnet_id}"
        private_ip_address_allocation = "Dynamic"
        #public_ip_address_id          = "${azurerm_public_ip.ip.id}"
        public_ip_address_id           = "${element(azurerm_public_ip.ip.*.id, count.index)}"
     }

}


resource "azurerm_virtual_machine" "vm" {
    count                   = "${var.vm_count}"
    name                    = "${var.vm_name}${count.index}"
    location                = "${var.vm_location}"
    resource_group_name     = "${var.vm_resource_group}"
    network_interface_ids   = ["${element(azurerm_network_interface.nic.*.id, count.index)}"]
    vm_size                 = "Standard_DS1_v2"

    storage_os_disk {
        name                = "${var.vm_name}${count.index}_osdisk"
        caching             = "ReadWrite"
        create_option       = "FromImage"
        managed_disk_type   = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "${var.vm_name}${count.index}"
        admin_username = "azureuser"
        admin_password = "${var.vm_password}"
    }

    # Warning: Password authentication should be disabled for real-world deployments
    os_profile_linux_config {
        disable_password_authentication = false

    /*
        disable_password_authentication = false
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
            key_data = "ssh-rsa AAAAB3Nz{snip}hwhqT9h"
        }
    */
    }

    tags {
        patch_window = "${var.vm_patch_window_tag_value}"
    }

}

# deploy the oms extension to onboard the VM to Log Analytics
resource "azurerm_virtual_machine_extension" "oms_extension" {
  count                         = "${var.vm_count}"
  name                          = "${element(azurerm_virtual_machine.vm.*.name, count.index)}_omsExtension"
  location                      = "${var.vm_location}"
  resource_group_name           = "${var.vm_resource_group}"
  virtual_machine_name          = "${element(azurerm_virtual_machine.vm.*.name, count.index)}"
  publisher                     = "Microsoft.EnterpriseCloud.Monitoring"
  type                          = "OmsAgentForLinux"
  type_handler_version          = "1.7"
  auto_upgrade_minor_version    = true

  settings = <<SETTINGS
    {
        "workspaceId" : "${var.workspace_id}"
    }
SETTINGS

  protected_settings = <<PROTECTEDSETTINGS
    {
        "workspaceKey" : "${var.workspace_key}"
    }
PROTECTEDSETTINGS
}

