# ---------------------------------------------------------------------------
# Resource Groups - one per subscription/site
# ---------------------------------------------------------------------------

resource "azurerm_resource_group" "onprem" {
  provider = azurerm.onprem

  name     = var.onprem_resource_group_name
  location = var.location
}

resource "azurerm_resource_group" "hub" {
  provider = azurerm.hub

  name     = var.hub_resource_group_name
  location = var.location
}

# ---------------------------------------------------------------------------
# Site 1 - simulated on-prem network (onprem_subscription_id)
# ---------------------------------------------------------------------------

resource "azurerm_virtual_network" "onprem" {
  provider = azurerm.onprem

  name                = "vnet-${var.onprem_name}"
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name
  address_space       = var.onprem_vnet_address_space
}

resource "azurerm_subnet" "onprem_workload" {
  provider = azurerm.onprem

  name                 = "snet-workload"
  resource_group_name  = azurerm_resource_group.onprem.name
  virtual_network_name = azurerm_virtual_network.onprem.name
  address_prefixes     = [var.onprem_subnet_address_prefix]
}

# Name MUST be exactly "GatewaySubnet" - Azure requirement
resource "azurerm_subnet" "onprem_gateway" {
  provider = azurerm.onprem

  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.onprem.name
  virtual_network_name = azurerm_virtual_network.onprem.name
  address_prefixes     = [var.onprem_gateway_subnet_prefix]
}

# ---------------------------------------------------------------------------
# Site 2 - hub / "real" Azure side (hub_subscription_id)
# ---------------------------------------------------------------------------

resource "azurerm_virtual_network" "hub" {
  provider = azurerm.hub

  name                = "vnet-${var.hub_name}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = var.hub_vnet_address_space
}

resource "azurerm_subnet" "hub_workload" {
  provider = azurerm.hub

  name                 = "snet-workload"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_subnet_address_prefix]
}

resource "azurerm_subnet" "hub_gateway" {
  provider = azurerm.hub

  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.hub_gateway_subnet_prefix]
}
