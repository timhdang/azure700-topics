# ---------------------------------------------------------------------------
# Public IPs - one per gateway
# ---------------------------------------------------------------------------

resource "azurerm_public_ip" "onprem_gw_pip" {
  provider = azurerm.onprem

  name                = "pip-vgw-${var.onprem_name}"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

resource "azurerm_public_ip" "hub_gw_pip" {
  provider = azurerm.hub

  name                = "pip-vgw-${var.hub_name}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

# ---------------------------------------------------------------------------
# VPN Gateway 1 (onprem / simulated on-prem, onprem_subscription_id)
# ---------------------------------------------------------------------------

resource "azurerm_virtual_network_gateway" "onprem" {
  provider = azurerm.onprem

  name                = "vgw-${var.onprem_name}"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name

  type          = "Vpn"
  vpn_type      = "RouteBased"
  sku           = var.gateway_sku
  active_active = false
  enable_bgp    = false

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.onprem_gw_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.onprem_gateway.id
  }
}

# ---------------------------------------------------------------------------
# VPN Gateway 2 (hub / hub, hub_subscription_id)
# ---------------------------------------------------------------------------

resource "azurerm_virtual_network_gateway" "hub" {
  provider = azurerm.hub

  name                = "vgw-${var.hub_name}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  type          = "Vpn"
  vpn_type      = "RouteBased"
  sku           = var.gateway_sku
  active_active = false
  enable_bgp    = false

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.hub_gw_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub_gateway.id
  }

  vpn_client_configuration {
    address_space        = var.p2s_client_address_pool
    vpn_client_protocols = ["OpenVPN"]
    vpn_auth_types        = ["AAD"]

    aad_tenant   = "https://login.microsoftonline.com/${var.tenant_id}/"
    aad_audience = var.p2s_aad_audience
    aad_issuer   = "https://sts.windows.net/${var.tenant_id}/"
  }
}
