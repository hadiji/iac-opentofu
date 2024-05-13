variable "enabled" {
  type        = bool
  description = "Set to false to prevent the module from creating any resources."
  default     = true
}


variable "admin_username" {
  description = "The administrator login name for the new SQL Server"
  default     = null
}

variable "mysql_server_name" {
  type    = string
  default = ""
}
variable "admin_password" {
  type        = string
  description = "The password associated with the admin_username user"
  default     = null
}

variable "admin_password_length" {
  type        = number
  default     = 16
  description = "Length of random password generated."
}

variable "backup_retention_days" {
  type        = number
  default     = 7
  description = "The backup retention days for the MySQL Flexible Server. Possible values are between 1 and 35 days. Defaults to 7"
}

variable "delegated_subnet_id" {
  description = "The resource ID of the subnet"
  type        = string
  default     = ""
}

variable "sku_name" {
  type        = string
  default     = "B_Standard_B1s"
  description = " The SKU Name for the MySQL Flexible Server."
}

variable "create_mode" {
  type        = string
  description = "The creation mode. Can be used to restore or replicate existing servers. Possible values are `Default`, `Replica`, `GeoRestore`, and `PointInTimeRestore`. Defaults to `Default`"
  default     = "Default"
}

variable "geo_redundant_backup_enabled" {
  type        = bool
  default     = true
  description = "Should geo redundant backup enabled? Defaults to false. Changing this forces a new MySQL Flexible Server to be created."
}

variable "replication_role" {
  type        = string
  default     = null
  description = "The replication role. Possible value is None."
}

variable "mysql_version" {
  type        = string
  default     = "5.7"
  description = "The version of the MySQL Flexible Server to use. Possible values are 5.7, and 8.0.21. Changing this forces a new MySQL Flexible Server to be created."
}

variable "location" {}
variable "resource_group_name" {}
variable "mysql_name" {}

variable "private_dns" {
  type    = bool
  default = false
}

variable "existing_private_dns_zone_id" {
  type    = string
  default = ""
}

variable "point_in_time_restore_time_in_utc" {
  type        = string
  default     = null
  description = " The point in time to restore from creation_source_server_id when create_mode is PointInTimeRestore. Changing this forces a new MySQL Flexible Server to be created."
}

variable "source_server_id" {
  type        = string
  default     = null
  description = "The resource ID of the source MySQL Flexible Server to be restored. Required when create_mode is PointInTimeRestore, GeoRestore, and Replica. Changing this forces a new MySQL Flexible Server to be created."
}

variable "auto_grow_enabled" {
  type        = bool
  default     = false
  description = "Should Storage Auto Grow be enabled? Defaults to true."
}
variable "iops" {
  type        = number
  default     = 360
  description = "The storage IOPS for the MySQL Flexible Server. Possible values are between 360 and 20000."
}

variable "size_gb" {
  type        = string
  default     = "20"
  description = "The max storage allowed for the MySQL Flexible Server. Possible values are between 20 and 16384."
}

variable "high_availability" {
  description = "Map of high availability configuration: https://docs.microsoft.com/en-us/azure/mysql/flexible-server/concepts-high-availability. `null` to disable high availability"
  type = object({
    mode                      = string
    standby_availability_zone = optional(number)
  })
  default = {
    mode                      = "SameZone"
    standby_availability_zone = 1
  }
}

variable "tags" {
  description = "(Optional) Specifies the tags "
  type        = map(any)
  default     = {}
}
