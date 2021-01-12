output "azurerm_public_ip_addr" {
    value       = azurerm_public_ip.main.ip_address
    description = "Public IP"
}

output "azurerm_network_interface_id"{
    value       = azurerm_network_interface.main.id
}