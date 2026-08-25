variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "westus2"
}

# ---------------------------------------------------------------------------
# Subscriptions
# onprem (onprem)  -> deployed into onprem_subscription_id
# hub (hub)     -> deployed into hub_subscription_id
# ---------------------------------------------------------------------------

variable "onprem_subscription_id" {
  description = "Subscription ID where the simulated on-prem site (onprem) resources are created"
  type        = string
  default     = ""
}

variable "hub_subscription_id" {
  description = "Subscription ID where the hub/Azure site (hub) resources are created"
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------
# Site 1 = "on-prem" simulated in Azure
# Site 2 = "Azure" / hub (the other end of the tunnel)
# ---------------------------------------------------------------------------

variable "onprem_name" {
  description = "Short name for site 1 (simulated on-prem)"
  type        = string
  default     = "onprem"
}

variable "onprem_resource_group_name" {
  description = "Resource group for site 1 resources, created in onprem_subscription_id"
  type        = string
  default     = "s2s-vpn-onprem-rg"
}

variable "onprem_vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "onprem_subnet_address_prefix" {
  type    = string
  default = "10.0.1.0/24"
}

variable "onprem_gateway_subnet_prefix" {
  type    = string
  default = "10.0.255.0/27"
}

variable "hub_name" {
  description = "Short name for site 2 (Azure/hub side)"
  type        = string
  default     = "azure"
}

variable "hub_resource_group_name" {
  description = "Resource group for site 2 resources, created in hub_subscription_id"
  type        = string
  default     = "s2s-vpn-hub-rg"
}

variable "hub_vnet_address_space" {
  type    = list(string)
  default = ["10.1.0.0/16"]
}

variable "hub_subnet_address_prefix" {
  type    = string
  default = "10.1.1.0/24"
}

variable "hub_gateway_subnet_prefix" {
  type    = string
  default = "10.1.255.0/27"
}

variable "gateway_sku" {
  description = "SKU for both virtual network gateways"
  type        = string
  default     = "VpnGw1AZ"
}

variable "shared_key" {
  description = "Pre-shared key (PSK) used by both IPsec connections. Override in a tfvars file / secret store — do not commit a real key."
  type        = string
  default     = "ChangeThisSharedKey123!"
  sensitive   = true
}
