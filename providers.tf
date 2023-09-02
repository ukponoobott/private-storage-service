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
  subscription_id = var.branch_subscription_id
  client_id       = var.branch_client_id
  client_secret   = var.branch_client_secret
  tenant_id       = var.branch_tenant_id
  alias           = "branch"
}


