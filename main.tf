resource "azurerm_resource_group" "rg" {
  name     = "minecraft-prod-rg"
  location = "westeurope"
}

resource "azurerm_storage_account" "storage" {
  name                     = "moonenminecraftprod"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
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

resource "azurerm_container_group" "containers" {
  name                = "minecraft"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  dns_name_label      = "moonenminecraftprod"
  os_type             = "Linux"

  container {
    name   = "studio"
    image  = "hashicraft/minecraft:v1.18.2-fabric"
    cpu    = 1
    memory = 4

    ports {
      port     = 25565
      protocol = "TCP"
    }

    volume {
      name                 = "world"
      mount_path           = "/minecraft/world"
      storage_account_name = azurerm_storage_account.storage.name
      storage_account_key  = azurerm_storage_account.storage.primary_access_key
      share_name           = azurerm_storage_share.world_share.name
    }

    volume {
      name                 = "config"
      mount_path           = "/minecraft/config"
      storage_account_name = azurerm_storage_account.storage.name
      storage_account_key  = azurerm_storage_account.storage.primary_access_key
      share_name           = azurerm_storage_share.config_share.name
    }

    environment_variables = {
      JAVA_MEMORY       = "4G",
      MINECRAFT_MOTD    = "My Minecraft Server!!",
      WHITELIST_ENABLED = true
    }
  }
}
