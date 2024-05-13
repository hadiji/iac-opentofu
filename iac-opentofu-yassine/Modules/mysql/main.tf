resource "azurerm_mysql_flexible_server" "main" {
  count                             = var.enabled ? 1 : 0
  name                              = var.mysql_name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  tags                              = var.tags
  administrator_login               = var.admin_username
  administrator_password            = var.admin_password == null ? random_password.main[0].result : var.admin_password
  backup_retention_days             = var.backup_retention_days
  delegated_subnet_id               = var.delegated_subnet_id
  sku_name                          = var.sku_name
  create_mode                       = var.create_mode
  geo_redundant_backup_enabled      = var.geo_redundant_backup_enabled
  point_in_time_restore_time_in_utc = var.create_mode == "PointInTimeRestore" ? var.point_in_time_restore_time_in_utc : null
  replication_role                  = var.replication_role
  source_server_id                  = var.create_mode == "PointInTimeRestore" ? var.source_server_id : null

  storage {
    auto_grow_enabled = var.auto_grow_enabled
    iops              = var.iops
    size_gb           = var.size_gb
  }

  dynamic "high_availability" {
    for_each = toset(var.high_availability != null ? [var.high_availability] : [])

    content {
      mode                      = high_availability.value.mode
      standby_availability_zone = lookup(high_availability.value, "standby_availability_zone", 1)
    }
  }

  version = var.mysql_version
  lifecycle {
    ignore_changes = [
      zone, # Ignorer les modifications de la zone de disponibilité
    ]
  }
}

resource "random_password" "main" {
  count       = var.admin_password == null ? 1 : 0
  length      = 16
  min_upper   = 4
  min_lower   = 2
  min_numeric = 4
  special     = false

}
