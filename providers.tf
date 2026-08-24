terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}


provider "azurerm" {
  alias = "hub"
  features {}
  subscription_id = var.hub_subscription_id
}


provider "azurerm" {
  alias = "onprem"
  features {}
  subscription_id = var.onprem_subscription_id
}
