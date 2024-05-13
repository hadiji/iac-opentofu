variable "name" {
  description = "(Required) Specifies the name of the jympbox host"
  type        = string
}
variable "admin_username" {
  description = "(Required) Specifies the vm_user of vm"
  type        = string
}

variable "admin_password" {
  description = "(Required) Specifies the vm_user of vm"
  type = string
}

variable vm_user {
  description = "(Required) Specifies the username of the virtual machine"
  type        = string
  default     = "ValuesJumpBox"
}

variable resource_group_name {
  description = "Resource Group name"
  type        = string
}

variable location {
  description = "Location in which to deploy the bastion"
  type        = string
}

variable "size" {
  description = "(Required) Specifies the size of vm"
  type        = string
}

variable "subnet_id" {
  description = "(Required) Specifies the subnet id of vm"
  type        = string
}

variable "os_disk_caching" {
  description = "Type de mise en cache pour le disque système"
  type        = string
  default = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "Type de compte de stockage pour le disque système"
  type        = string
  default = "Standard_LRS"
}

variable "image_publisher" {
  description = "Éditeur de l'image de la source"
  type        = string
  default = "Canonical"
}

variable "image_offer" {
  description = "Offre de l'image de la source"
  type        = string
  default = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "SKU de l'image de la source"
  type        = string
  default = "22_04-lts"
}

variable "image_version" {
  description = "Version de l'image de la source"
  type        = string
  default = "latest"
}

variable "ip_configuration_name" {
  description = "Nom de la configuration IP"
  type        = string
  default = "ConfigurationNicVm"
}

variable "private_ip_address_allocation" {
  description = "Allocation de l'adresse IP privée"
  type        = string
  default = "Dynamic"
}

variable "tags" {
  description = "(Optional) Specifies the tags of the storage account"
  default     = {}
}