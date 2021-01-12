#--------------------------------------------------------------
# virtual machine extension
#--------------------------------------------------------------
resource "azurerm_virtual_machine_extension" "main" {
  name                       = var.name
  virtual_machine_id         = var.virtual_machine_id
  type                       = var.options["type"]
  publisher                  = var.options["publisher"]
  type_handler_version       = var.options["type_version"]
  auto_upgrade_minor_version = var.options["is_auto_upgrade_minor_version"]

  settings           = <<SETTINGS
	${var.extention_settings}
	SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
  ${var.extention_protected}
  PROTECTED_SETTINGS
}
