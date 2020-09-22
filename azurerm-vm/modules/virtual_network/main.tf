#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "location" {}
variable "resource_group_name" {}
variable "virtual_network_name" {}

#--------------------------------------------------------------
# Virtual Network
#--------------------------------------------------------------
resource "azurerm_virtual_network" "main" {
    name                = var.virtual_network_name
    address_space       = ["172.0.0.0/16"]
    location            = var.location
    resource_group_name = var.resource_group_name

    tags = {
        environment = "Terraform Demo"
    }
}

#--------------------------------------------------------------
# Subnet
#--------------------------------------------------------------
resource "azurerm_subnet" "subnet_o" {
    name                 = "mySTerrafom_o"
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes     = ["172.0.1.0/24"]
}

resource "azurerm_subnet" "subnet_t" {
    name                 = "mySTerrafom_t"
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes     = ["172.0.2.0/24"]
}

#--------------------------------------------------------------
# Public IP
#--------------------------------------------------------------
resource "azurerm_public_ip" "main" {
    name                         = "myPITerraform"
    location                     = var.location
    resource_group_name          = var.resource_group_name
    allocation_method            = "Dynamic"

    depends_on = [var.resource_group_name]

    tags = {
        environment = "Terraform Demo"
    }
}

#--------------------------------------------------------------
# Security Group
#--------------------------------------------------------------
resource "azurerm_network_security_group" "main" {
    name                = "mySGTerraform"
    location            = var.location
    resource_group_name = var.resource_group_name
    
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

    depends_on = [var.resource_group_name]
    
    tags = {
        environment = "Terraform Demo"
    }
}

#--------------------------------------------------------------
# Network Interface
#--------------------------------------------------------------
resource "azurerm_network_interface" "main" {
    name                        = "myNITerraform"
    location                    = var.location
    resource_group_name         = var.resource_group_name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.subnet_t.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.main.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
    network_interface_id      = azurerm_network_interface.main.id
    network_security_group_id = azurerm_network_security_group.main.id
}