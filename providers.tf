terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.50.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "random" {
  # Configuration options
}


# remote provider-branch
provider "azurerm" {
  features {}
  subscription_id = var.sandbox_subscription_id
  client_id       = var.sandbox_client_id
  client_secret   = var.sandbox_client_secret
  tenant_id       = var.sandbox_tenant_id
  alias           = "branch"
}


