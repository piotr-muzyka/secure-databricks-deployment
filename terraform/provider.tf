terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.99"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "ba954b59-c252-44c0-af9a-aa4106941d77"
}
