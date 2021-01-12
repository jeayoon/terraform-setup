#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "location" {}
variable "resource_group_name" {}
variable "azurerm_network_interface_id" {}

#--------------------------------------------------------------
# Storage Account
#--------------------------------------------------------------
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = var.resource_group_name
  }

  byte_length = 8
}

resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_replication_type = "LRS"
  account_tier             = "Standard"

  depends_on = [var.resource_group_name]
  tags = {
    environment = "Terraform Demo"
  }
}

#--------------------------------------------------------------
# Virtual machine
#--------------------------------------------------------------
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "myterraformvm" {
  name                  = "myVMTerraform"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [var.azurerm_network_interface_id]
  size                  = "Standard_B1ls"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  depends_on = [var.resource_group_name]

  tags = {
    environment = "Terraform Demo"
  }
}
