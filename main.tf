resource "azurerm_resource_group" "rg" {
  name     = "minecraft-prod-rg"
  location = "westeurope"
}

resource "azurerm_storage_account" "storage" {
  name                     = "moonenminecraftprod"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  access_tier              = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "prod"
  }
}

resource "azurerm_storage_share" "world_share" {
  name                 = "world"
  storage_account_name = azurerm_storage_account.storage.name
  quota                = 50
}

resource "azurerm_storage_share" "config_share" {
  name                 = "config"
  storage_account_name = azurerm_storage_account.storage.name
  quota                = 1
}
