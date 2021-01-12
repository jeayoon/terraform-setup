#---------------------------------
# Configure the Azure Provider
#---------------------------------
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.29.0"
    }
  }
  required_version = "= 0.13.5"
}
provider "azurerm" {
  features {}
}

#---------------------------------
# tfstate backend
#---------------------------------
terraform {
  backend "azurerm" {
    resource_group_name  = "RG-terraform"
    storage_account_name = "terraformstg1234"
    container_name       = "tfstate"
    key                  = "production.tfstate"
  }
}

#---------------------------------
# Time
#---------------------------------
provider "time" {
  version = "~> 0.4"
}
# Store 10 years in the future
resource "time_offset" "sas_expiry" {
  offset_years = 10
}

# Store (now - 10) days to ensure we have valid SAS
resource "time_offset" "sas_start" {
  offset_days = -10
}


#---------------------------------
# Modules
#---------------------------------
#---------------------------------
# Resource Group
#---------------------------------
module "resource_group" {
  source = "../modules/resource_group"

  location            = var.location
  resource_group_name = var.resource_group_name
}

#---------------------------------
# Storag Account
#---------------------------------
module "storage_account" {
  source = "../modules/storage"

  location            = var.location
  resource_group_name = var.resource_group_name
}

#---------------------------------
# Virtual Network
#---------------------------------
module "virtual_network" {
  source = "../modules/virtual_network"

  location             = var.location
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
}

#---------------------------------
# Virtual Machine
#---------------------------------
module "vm_linux" {
  source = "../modules/vm_linux"

  location                     = var.location
  vm_username                  = var.vm_username
  vm_password                  = var.vm_password
  resource_group_name          = module.resource_group.name
  azurerm_network_interface_id = module.virtual_network.azurerm_network_interface_id
}
module "vm_windows" {
  source = "../modules/vm_windows"

  location                     = var.location
  vm_username                  = var.vm_username
  vm_password                  = var.vm_password
  resource_group_name          = module.resource_group.name
  azurerm_network_interface_id = module.virtual_network.azurerm_network_interface_id
}

#---------------------------------
# Windows Extention
#---------------------------------
module "diag_extention_windows" {
  source = "../modules/vm_extension"

  name                         = var.windows_extension_name
  options                      = var.common_win_diag_ext_options
  virtual_machine_id           = module.vm_windows.id
  extention_settings           = var.windows_diag_ext_settings
  extention_protected          = var.windows_diag_ext_protected
}
#---------------------------------
# Linux Extention
#---------------------------------
module "diag_extention_linux" {
  source = "../modules/vm_extension"

  name                         = var.linux_extension_name
  options                      = var.common_linux_diag_ext_options
  virtual_machine_id           = module.vm_linux.id
  extention_settings           = var.linux_diag_ext_settings
  extention_protected          = var.linux_diag_ext_protected
}
