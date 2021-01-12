#--------------------------------------------------------------
# Variable Settings
#--------------------------------------------------------------
variable "location" {}
variable "vm_username" {}
variable "vm_password" {}
variable "resource_group_name" {}
variable "virtual_network_name" {}
variable "windows_extension_name" {}
variable "linux_extension_name" {}

variable "common_win_diag_ext_options" {
  description = "Windows Diagnostic Settings Extention options"
  type        = map(any)
  default = {
    type                          = "IaasDiagnostics"
    publisher                     = "Microsoft.Azure.Diagnostics"
    type_version                  = "1.5"
    is_auto_upgrade_minor_version = true
  }
}

#-----------------------
# Linux Extension
#-----------------------
variable "common_linux_diag_ext_options" {
  description = "Linux Diagnostic Settings Extention options"
  type        = map(any)
  default = {
    type                          = "LinuxDiagnostic"
    publisher                     = "Microsoft.Azure.Diagnostics"
    type_version                  = "3.0"
    is_auto_upgrade_minor_version = true
  }
}

#---------------------------------
# Windows Diagnostic Settings Extension
#---------------------------------
data "template_file" "windows_diag_ext_protected" {
  template = file("../modules/vm_windows/files/def_diag_ext_protected.json.tpl")

  vars = {
    storage_key  = module.storage_account.prim_acs_key
    storage_name = module.storage_account.name
  }
}
data "template_file" "windows_diag_ext_settings" {
  template = file("../modules/vm_windows/files/def_diag_ext_settings.json.tpl")

  vars = {
    vm_id        = module.vm_windows.id
    storage_name = module.storage_account.name
  }
}

#---------------------------------
# Linux Diagnostic Settings Extension
#---------------------------------
data "azurerm_storage_account_sas" "main" {
  connection_string = module.storage_account.prim_connect_str
  https_only        = true

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    table = true
    queue = false
    file  = false
  }

  start  = time_offset.sas_start.rfc3339
  expiry = time_offset.sas_expiry.rfc3339

  permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = true
    create  = true
    update  = true
    process = true
  }
}


data "template_file" "linux_diag_ext_protected" {
  template = file("../modules/vm_linux/files/def_diag_ext_protected.json.tpl")

  vars = {
    storage_name  = module.storage_account.name
    storage_token = data.azurerm_storage_account_sas.main.sas
  }
}
data "template_file" "linux_diag_ext_settings" {
  template = file("../modules/vm_linux/files/def_diag_ext_settings.json.tpl")

  vars = {
    vm_id        = module.vm_linux.id
    storage_name = module.storage_account.name
  }
}
