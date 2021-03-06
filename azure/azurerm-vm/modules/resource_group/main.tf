#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "resource_group_name" {}
variable "location" {}

#--------------------------------------------------------------
# Resource Group
#--------------------------------------------------------------
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "Terraform Demo"
  }
}
