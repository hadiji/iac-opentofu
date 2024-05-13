variable "resource_group_name" {
    description = "The resource group name"
}

variable "resource_group_location" {
    description = "The resource group location"
}

variable "tags" {
    description = "(Optional) Specifies the tags of the storage account"
    default     = {}
}
