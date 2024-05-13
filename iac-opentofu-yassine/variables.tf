variable "location" {
  description = "The resource group location"
  default =""
}

variable "resource_prefix" {
  description = "The resource prefix"
}

variable "resource_postfix" {
  description = "the resource postfix"
}

variable "resource_prefix_spec" {
  description = " the resource prefix spec "
}
variable "resource_postfix_spec" {
  description = " the resource postfix spec"
}

variable "resource_group_name_hub" {
  description = "the resource groupe name of hub"
}

variable "resource_group_name_spoke" {
  description = "the resource groupe name of spoke "
}

variable "hub_vnet_name" {
  description = "Specifies the name of the hub virtual virtual network"
  type        = string
}

variable "hub_address_space" {
  description = "Specifies the address space of the hub virtual virtual network"
  type        = list(string)
}

variable "name_subnet_bastion" {
  description = "the name of subnet bastion "
  default = "BastionSubnet"
}

variable "name_subnet_gateway" {
  description = "the name of subnet gateway"
  default = "GatewaySubnet"
}

variable "name_subnet_aks" {
  description = "the name of subnet aks "
  default = "aks-subnet"
}

variable "name_subnet_JumpBox" {
  description = "the name of subnet jumpBox "
  default = "JumpBox-subnet"
}

variable "name_subnet_app_gateway" {
  description = "the name of subnet application gateway  "
  default = "Azure-App-gateway-subnet"
}

variable "name_subnet_privite_link" {
  description = "the name of subnet private link  "
  default = "Private-link-subnet"
}

variable "name_subnet_mysql" {
  description = "the name of subnet mysql  "
  default = "MySQL-subnet"
}

variable "hub_bastion_subnet_address_prefix" {
  description = "Specifies the address prefix of the bastion subnet"
  type        = list(string)
}

variable "hub_gateway_subnet_address_prefix" {
  description = "Specifies the address prefix of the bastion subnet"
  type        = list(string)
}

variable "spoke_vnet_name" {
  description = "Specifies the name of the AKS subnet"
  type        = string
}

variable "spoke_vnet_address_space" {
  description = "Specifies the address space of the AKS adress"
  type        = list(string)
}

variable "aks_subnet_address_prefix" {
  description = "Specifies the address prefix of the aks subnet"
  type        = list(string)
}

variable "jumbox_subnet_address_prefix" {
  description = "Specifies the address prefix of the jumbox subnet"
  type        = list(string)
}

variable "app_gateway_subnet_address_prefix" {
  description = "Specifies the address prefix of the app gateway subnet"
  type        = list(string)
}

variable "Private_link_subnet_address_prefix" {
  description = "Specifies the address prefix of the private link subnet"
  type        = list(string)
}
variable "Mysql_subnet_address_prefix" {
  description = "Specifies the address prefix of the Mysql subnet"
  type        = list(string)
}

variable "acr_sku" {
  description = "Specifies the name of the container registry"
  type        = string
  default     = "Premium" //need to be like this

  validation {
    condition = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "The container registry sku is invalid."
  }
}

variable "acr_admin_enabled" {
  description = "Specifies whether admin is enabled for the container registry"
  type        = bool
  default     = true
}

variable "acr_georeplication_locations" {
  description = "(Optional) A list of Azure locations where the container registry should be geo-replicated."
  type        = list(string)
  default     = []
}

variable "key_vault_sku_name" {
  description = "(Required) The Name of the SKU used for this Key Vault. Possible values are standard and premium."
  type        = string
  default     = "standard"

  validation {
    condition = contains(["standard", "premium" ], var.key_vault_sku_name)
    error_message = "The sku name of the key vault is invalid."
  }
}

variable"key_vault_enabled_for_deployment" {
  description = "(Optional) Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. Defaults to false."
  type        = bool
  default     = true
}

variable"key_vault_enabled_for_disk_encryption" {
  description = " (Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to false."
  type        = bool
  default     = true
}

variable"key_vault_enabled_for_template_deployment" {
  description = "(Optional) Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. Defaults to false."
  type        = bool
  default     = true
}

variable"key_vault_enable_rbac_authorization" {
  description = "(Optional) Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. Defaults to false."
  type        = bool
  default     = true
}

variable"key_vault_purge_protection_enabled" {
  description = "(Optional) Is Purge Protection enabled for this Key Vault? Defaults to false."
  type        = bool
  default     = true
}

variable "key_vault_soft_delete_retention_days" {
  description = "(Optional) The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days."
  type        = number
  default     = 30
}

variable "key_vault_bypass" { 
  description = "(Required) Specifies which traffic can bypass the network rules. Possible values are AzureServices and None."
  type        = string
  default     = "AzureServices" 

  validation {
    condition = contains(["AzureServices", "None" ], var.key_vault_bypass)
    error_message = "The valut of the bypass property of the key vault is invalid."
  }
}

variable "key_vault_default_action" { 
  description = "(Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny."
  type        = string
  default     = "Allow" 

  validation {
    condition = contains(["Allow", "Deny" ], var.key_vault_default_action)
    error_message = "The value of the default action property of the key vault is invalid."
  }
}

variable "storage_account_kind" {
  description = "(Optional) Specifies the account kind of the storage account"
  default     = "StorageV2"
  type        = string

   validation {
    condition = contains(["Storage", "StorageV2"], var.storage_account_kind)
    error_message = "The account kind of the storage account is invalid."
  }
}

variable "storage_account_tier" {
  description = "(Optional) Specifies the account tier of the storage account"
  default     = "Standard"
  type        = string

   validation {
    condition = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "The account tier of the storage account is invalid."
  }
}

variable "storage_account_replication_type" {
  description = "(Optional) Specifies the replication type of the storage account"
  default     = "LRS"
  type        = string

  validation {
    condition = contains(["LRS", "ZRS", "GRS", "GZRS", "RA-GRS", "RA-GZRS"], var.storage_account_replication_type)
    error_message = "The replication type of the storage account is invalid."
  }
}

variable "vm_size" {
  description = "Specifies the size of the jumpbox virtual machine"
  default     = "Standard_DS1_v2"
  type        = string
}

variable "admin_username" {
  description = "(Required) Specifies the admin username of the jumpbox virtual machine and AKS worker nodes."
  type        = string
  default     = "valueadmin"
}

variable "admin_password" {
  default = "Hello@12345#"
}


variable "automatic_channel_upgrade" {
  description = "(Optional) The upgrade channel for this Kubernetes Cluster. Possible values are patch, rapid, and stable."
  default     = "stable"
  type        = string

  validation {
    condition = contains( ["patch", "rapid", "stable"], var.automatic_channel_upgrade)
    error_message = "The upgrade mode is invalid."
  }
}


variable "admin_group_object_ids" {
  description = "(Optional) A list of Object IDs of Microsoft Entra ID Groups which should have Admin Role on the Cluster."
  default = ["604f1a96-cbe8-43f8-abbf-f8eaf5d85730", "78761057-c58c-44b7-aaa7-ce1639c6c4f5"]
  type        = list(string)
}

variable "azure_rbac_enabled" {
  description = "(Optional) Is Role Based Access Control based on Microsoft Entra ID enabled?"
  default     = true
  type        = bool
}

variable "role_based_access_control_enabled" {
  description = "(Required) Is Role Based Access Control Enabled? Changing this forces a new resource to be created."
  default     = true
  type        = bool
}

variable "sku_tier" {
  description = "(Optional) The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA). Defaults to Free."
  default     = "Free"
  type        = string

  validation {
    condition = contains( ["Free", "Paid"], var.sku_tier)
    error_message = "The sku tier is invalid."
  }
}

variable "kubernetes_version" {
  description = "Specifies the AKS Kubernetes version"
  default     = "1.27"
  type        = string
}

variable "private_cluster_enabled" {
  description = "Should this Kubernetes Cluster have its API server only exposed on internal IP addresses? This provides a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located. Defaults to false. Changing this forces a new resource to be created."
  type        = bool
  default     = true
}


variable "default_node_pool_vm_size" {
  description = "Specifies the vm size of the default node pool"
  default     = "Standard_F8s_v2"
  type        = string
}

variable "default_node_pool_availability_zones" {
  description = "Specifies the availability zones of the default node pool"
  default     = ["1", "2", "3"]
  type        = list(string)
}

variable "default_node_pool_enable_auto_scaling" {
  description = "(Optional) Whether to enable auto-scaler. Defaults to true."
  type          = bool
  default       = true
}

variable "node_resource_group" {
  description = "Specifies the node resource group"
  default = "nodeAksRg"
}

variable "network_plugin" {
  description = "Specifies the network plugin of the AKS cluster"
  default     = "azure"
  type        = string
}

variable "secret_rotation_enabled" {
  default = true
}

variable "app_gateway_sku" {
  default =  { size = " Standard_v2" , 
               tier = "WAF_v2"  }
}

variable "autoscale_configuration" {
  default = {
    min_capacity = "2"
    max_capacity = "5"
  }
}

variable "sku_size" {
  default = "WAF_v2"
}

variable "sku_tier_waf" {
  default = "WAF_v2"
}

variable "private_ip_address_frontend_ip_conf_appgw" {
  default = "10.240.5.10"
}

variable "private_ip_address_allocation_frontend_ip_conf_appgw" {
  default = "Static"
}
variable "name_backend_address_pools" {
  default = "backend-address-pool-1"
}

variable "name_http_listeners" {
  default = "http-listener"
}

variable "frontend_ip_configuration" {
  default = "Public"
}

variable "http_listeners_port" {
  default = "80"
}
variable "http_listeners_protocol" {
  default = "Http"
}

variable "backend_http_settings_name" {
  default = "backend-http-setting"
}

variable "backend_http_settings_port" {
  default = "80"
}

variable "backend_http_settings_protocol" {
  default = "Http"
}

variable "backend_http_settings_path" {
  default = "/path1/"
}

variable "request_routing_rules_name" {
  default = "request-routing-rule-1"
}
variable "waf_conf_firewall_mode" {
  default = "Detection"
}

variable "waf_conf_rule_set_version" {
  default = "3.1"
}

variable "waf_conf_enabled" {
  default = "true"
}

variable sku_name_mysql {
  type        = string
  description = " The SKU Name for the MySQL Flexible Server."
  default = "B_Standard_B1s"
}

variable "mysql_version" {
  type        = string
  default     = "8.0.21"
  description = "The version of the MySQL Flexible Server to use. Possible values are 5.7, and 8.0.21. Changing this forces a new MySQL Flexible Server to be created."
}

variable "mysql_server_name" {
  default = "testmysqlserver"
}

variable "private_dns" {
  type    = bool
  default = false
}

variable "admin_username_mysql" {
  description = "The administrator login name for the new SQL Server"
  default     = "mysqlusername"
}

variable admin_password_mysql {
  type        = string
  description = "The password associated with the admin_username user"
  default     = "ba5yatgfgfhdsv6A3ns2lu4gqzzc"
}

variable "auto_grow_enabled" {
  type        = bool
  default     = true
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





variable "allow_virtual_network_access_hub" {
  description = "Allow virtual network access for the first peering connection."
  type        = bool
  default     = true
}

variable "allow_forwarded_traffic_hub" {
  description = "Allow forwarded traffic from the first peering connection."
  type        = bool
  default     = true
}

variable "allow_gateway_transit_hub" {
  description = "Allow gateway transit for the first peering connection."
  type        = bool
  default     = true
}

variable "use_remote_gateways_hub" {
  description = "Allow using remote gateways in the first peering connection."
  type        = bool
  default     = false
}

variable "allow_virtual_network_access_spoke" {
  description = "Allow virtual network access for the second peering connection."
  type        = bool
  default     = true
}

variable "allow_forwarded_traffic_spoke" {
  description = "Allow forwarded traffic from the second peering connection."
  type        = bool
  default     = true
}

variable "allow_gateway_transit_spoke" {
  description = "Allow gateway transit for the second peering connection."
  type        = bool
  default     = false
}

variable "use_remote_gateways_spoke" {
  description = "Allow using remote gateways in the second peering connection."
  type        = bool
  default     = true
}