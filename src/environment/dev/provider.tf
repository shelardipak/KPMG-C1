provider "azurerm" {
    client_id = var.client_id
    client_secret = var.client_secret
    subscription_id = var.subscription_id
    tenant_id = var.tenant_id
    skip_provider_registration = true
    features {}
}


terraform {
   required_providers {
     azurerm = {
      source = "hashicorp/azurerm"
      version = "2.92.0"
    }
   }
}