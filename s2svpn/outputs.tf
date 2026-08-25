output "onprem_gateway_public_ip" {
  value = azurerm_public_ip.onprem_gw_pip.ip_address
}

output "hub_gateway_public_ip" {
  value = azurerm_public_ip.hub_gw_pip.ip_address
}

output "onprem_to_hub_connection_status" {
  description = "Run `terraform apply` then check in the portal/CLI; status is not exposed directly by this resource."
  value       = azurerm_virtual_network_gateway_connection.onprem_to_hub.id
}

output "hub_to_onprem_connection_status" {
  value = azurerm_virtual_network_gateway_connection.hub_to_onprem.id
}
