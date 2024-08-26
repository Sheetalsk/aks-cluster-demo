resource "azurerm_storage_account" "asa" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS" ##GZRS is highest available type - provides availablility across multiple zones and multiple regions

  tags = {
    environment = "staging"
  }
  
  depends_on = [azurerm_resource_group.rg]
}