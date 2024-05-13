variable resource_group_name {
  description = "Resource Group name"
  type        = string
}

variable location {
  description = "Location in which to deploy the bastion"
  type        = string
}

variable "name" {
  description = "(Required) Specifies the name of the bastion host"
  type        = string
}

variable "allocation_method" {
  description = "Méthode d'allocation de l'adresse IP publique"
  default     = "Static"
}

variable "gateway_name" {
  description = "Nom de la passerelle VPN"
  default     = "NetGw"
}
variable "vpn_type" {
  description = "Type VPN de la passerelle"
  default     = "RouteBased"
}
variable "sku" {
  description = "SKU de la passerelle VPN"
  default     = "VpnGw1"
    validation {
    condition = contains(["Basic",
    "Standard",
    "HighPerformance",
    "UltraPerformance",
    "ErGw1AZ",
    "ErGw2AZ",
    "ErGw3AZ",
    "VpnGw1",
    "VpnGw2",
    "VpnGw3",
    "VpnGw4",
    "VpnGw5",
    "VpnGw1AZ",
    "VpnGw2AZ",
    "VpnGw3AZ",
    "VpnGw4AZ",
    "VpnGw5A"], var.sku)
    error_message = "The sku type is invalid."
  }

}
variable "subnet_id" {
  description = "ID du sous-réseau où se trouve la passerelle VPN"
}
variable "address_space" {
  description = "(Required) The address space out of which IP addresses for vpn clients will be taken. You can provide more than one address space, e.g. in CIDR notation."
  type        = list(string)
  default     = ["10.2.0.0/24"]
}

variable "name_ip_config" {
  default = "vnetGatewayConfig"
}

variable "private_ip_address_allocation" {
  default ="Dynamic"
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(any)
  default     = {}
}
