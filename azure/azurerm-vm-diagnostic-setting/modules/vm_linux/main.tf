#--------------------------------------------------------------
# virtual machine
#--------------------------------------------------------------
resource "azurerm_linux_virtual_machine" "main" {
  name                = "myLinuxVM"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_B1ls"
  admin_username      = var.vm_username
  admin_password      = var.vm_password
  network_interface_ids = [var.azurerm_network_interface_id]

  disable_password_authentication = false

	identity {
		type      = "SystemAssigned"
	}

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = "32"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8.0"
    version   = "latest"
  }
}
