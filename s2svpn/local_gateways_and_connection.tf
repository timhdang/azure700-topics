# ---------------------------------------------------------------------------
# Local Network Gateways
# Each one is the Azure-side "representation" of the REMOTE site: its
# public IP (the peer's gateway IP) + the address space that lives behind it.
# It lives in the SAME subscription/RG as the gateway that will use it.
# ---------------------------------------------------------------------------

# Represents hub, as seen from onprem's gateway (created in onprem_subscription_id)
resource "azurerm_local_network_gateway" "onprem_view_of_hub" {
  provider = azurerm.onprem

  name                = "lgw-${var.onprem_name}-to-${var.hub_name}"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name

  gateway_address = azurerm_public_ip.hub_gw_pip.ip_address
  address_space   = var.hub_vnet_address_space
}

# Represents onprem, as seen from hub's gateway (created in hub_subscription_id)
resource "azurerm_local_network_gateway" "hub_view_of_onprem" {
  provider = azurerm.hub

  name                = "lgw-${var.hub_name}-to-${var.onprem_name}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  gateway_address = azurerm_public_ip.onprem_gw_pip.ip_address
  address_space   = var.onprem_vnet_address_space
}

# ---------------------------------------------------------------------------
# Connections (IPsec) - one on each side, both using the same PSK
# ---------------------------------------------------------------------------

resource "azurerm_virtual_network_gateway_connection" "onprem_to_hub" {
  provider = azurerm.onprem

  name                = "conn-${var.onprem_name}-to-${var.hub_name}"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.onprem.id
  local_network_gateway_id   = azurerm_local_network_gateway.onprem_view_of_hub.id

  shared_key = var.shared_key
}

resource "azurerm_virtual_network_gateway_connection" "hub_to_onprem" {
  provider = azurerm.hub

  name                = "conn-${var.hub_name}-to-${var.onprem_name}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.hub.id
  local_network_gateway_id   = azurerm_local_network_gateway.hub_view_of_onprem.id

  shared_key = var.shared_key
}
