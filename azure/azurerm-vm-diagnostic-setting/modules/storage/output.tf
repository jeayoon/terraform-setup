output "name" {
  value = azurerm_storage_account.main.name
}

output "prim_acs_key" {
  value = azurerm_storage_account.main.primary_access_key
}

output "prim_connect_str" {
  value = azurerm_storage_account.main.primary_connection_string
}
