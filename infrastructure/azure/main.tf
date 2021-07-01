provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  features {

  }
}

provider "azuread" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}


terraform {
  backend "azurerm" {
  }
  
  required_providers {
    azurerm = {
      source  = "registry.terraform.io/hashicorp/azurerm"
      version = "~> 2.65.0"
    }

    azuread = {
      source  = "registry.terraform.io/hashicorp/azuread"
      version = "~> 1.6.0"
    }
  }
    
}