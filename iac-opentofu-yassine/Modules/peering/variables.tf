variable "vnet_1_name" {
  description = "Specifies the name of the first virtual network"
  type        = string
}

variable "vnet_1_id" {
  description = "Specifies the resource id of the first virtual network"
  type        = string
}

variable "vnet_1_rg" {
  description = "Specifies the resource group name of the first virtual network"
  type        = string
}

variable "vnet_2_name" {
  description = "Specifies the name of the second virtual network"
  type        = string
}

variable "vnet_2_id" {
  description = "Specifies the resource id of the second virtual network"
  type        = string
}

variable "vnet_2_rg" {
  description = "Specifies the resource group name of the second virtual network"
  type        = string
}

variable "peering_name_1_to_2" {
  description = "(Optional) Specifies the name of the first to second virtual network peering"
  type        = string
  default     = "peering1to2"
}

variable "peering_name_2_to_1" {
  description = "(Optional) Specifies the name of the second to first virtual network peering"
  type        = string
  default     = "peering2to1"
}

variable "allow_virtual_network_access_1" {
  description = "Allow virtual network access for the first peering connection."
  type        = bool
  default     = true
}

variable "allow_forwarded_traffic_1" {
  description = "Allow forwarded traffic from the first peering connection."
  type        = bool
  default     = true
}

variable "allow_gateway_transit_1" {
  description = "Allow gateway transit for the first peering connection."
  type        = bool
  default     = true
}

variable "use_remote_gateways_1" {
  description = "Allow using remote gateways in the first peering connection."
  type        = bool
  default     = false
}

variable "allow_virtual_network_access_2" {
  description = "Allow virtual network access for the second peering connection."
  type        = bool
  default     = true
}

variable "allow_forwarded_traffic_2" {
  description = "Allow forwarded traffic from the second peering connection."
  type        = bool
  default     = true
}

variable "allow_gateway_transit_2" {
  description = "Allow gateway transit for the second peering connection."
  type        = bool
  default     = false
}

variable "use_remote_gateways_2" {
  description = "Allow using remote gateways in the second peering connection."
  type        = bool
  default     = true
}