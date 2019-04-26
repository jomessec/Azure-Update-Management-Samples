
# vnet for the VMs
resource "azurerm_virtual_network" "vnet" {
    name                = "${var.resource_group_name}-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
}

# subnet for the VMs
resource "azurerm_subnet" "subnet" {
    name                 = "${var.resource_group_name}-subnet"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix       = "10.0.2.0/24"
}

# NSG for the VMs
resource "azurerm_network_security_group" "nsg" {
    name                = "${var.resource_group_name}-nsg"
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}
