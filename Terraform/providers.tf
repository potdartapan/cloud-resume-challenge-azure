terraform {
  required_version = ">= 1.2.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.24"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "c520661a-5fcd-4696-ad6f-c2c905800b80"
}