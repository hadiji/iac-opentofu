variable resource_group_name {
  description = "Resource Group name"
  type        = string
}

variable location {
  description = "Location in which to deploy the bastion"
  type        = string
}

variable "subnet_id" {
  description = "(Required) Specifies subnet id of the bastion host"
  type        = string
}

variable "name" {
  description = "(Required) Specifies the name of the bastion host"
  type        = string
}

variable "public_ip_location" {
  description = "Emplacement de l'adresse IP publique"
  type        = string
  default = "vaWest Europe"
}

variable "public_ip_sku" {
  description = "SKU de l'adresse IP publique"
  type        = string
  default = "Standard"
}

variable "public_ip_allocation_method" {
  description = "Méthode d'allocation de l'adresse IP publique"
  type        = string
  default = "Static"
}

variable "name_ip_configuration" {
  default = "configuration"
}

variable "tags" {
  description = "(Optional) Specifies the tags of the bastion host"
  default     = {}
}

