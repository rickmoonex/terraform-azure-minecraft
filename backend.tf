provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-prod-rg"
    storage_account_name = "moonentfstate"
    container_name       = "terraform-azure-minecraft"
    key                  = "production.tfstate"
  }
}
