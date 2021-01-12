#---------------------------------
# Configure the Azure Provider
#---------------------------------
provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you're using version 1.x, the "features" block is not allowed.
  version         = "~>2.0"
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name   = "myTerraform" 
    storage_account_name  = "storageterraformz123"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}

#--------------------------------------------------------------
# Module Resource Group Settings
#--------------------------------------------------------------
module "resource_group" {
  source = "../modules/resource_group"

  location = var.location
  resource_group_name = var.resource_group_name 
}

#--------------------------------------------------------------
# Module Virtual Network Settings
#--------------------------------------------------------------
module "virtual_network" {
  source = "../modules/virtual_network"

  location = var.location
  resource_group_name = var.resource_group_name
  virtual_network_name = var.virtual_network_name 
}

#--------------------------------------------------------------
# Module Virtual Machine Settings
#--------------------------------------------------------------
module "virtual_machine" {
  source = "../modules/virtual_machine"

  location = var.location
  resource_group_name = var.resource_group_name
  azurerm_network_interface_id = module.virtual_network.azurerm_network_interface_id
}