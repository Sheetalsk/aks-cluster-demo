resource "azurerm_container_registry" "acr" {
  name                     = var.container_registry_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = "Standard"   # standard -> cost-effective, no geo-replication or advanced security features
  admin_enabled            = false
  depends_on = [azurerm_resource_group.rg]
}

