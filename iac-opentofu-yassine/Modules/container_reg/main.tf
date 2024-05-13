resource "azurerm_container_registry" "acr" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = var.sku  
  admin_enabled            = var.admin_enabled
  tags                     = var.tags

  dynamic "georeplications" {
    for_each = var.georeplication_locations

    content {
      location = georeplications.value
      tags     = var.tags
    }
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}




