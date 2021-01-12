#--------------------------------------------------------------
# virtual machine
#--------------------------------------------------------------
resource "azurerm_windows_virtual_machine" "main" {
  name                = "myWindowsVM"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = "Standard_B1ls"
  admin_username      = var.vm_username
  admin_password      = var.vm_password
  network_interface_ids = [var.azurerm_network_interface_id]

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = "32"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
