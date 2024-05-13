data "azurerm_client_config" "current" {
}

locals {
  storage_account_prefix = "storage"
}

resource "random_string" "storage_account_suffix" {
  length  = 8
  special = false
  lower   = true
  upper   = false
  numeric  = false
}

/*
module "storage_state_file" {
  source                  = "./modules/storage_state_file"
  resource_prefix = var.resource_prefix
  resource_postfix = var.resource_postfix
  location = var.location

}
*/
module "hub_resource_group" {
  source                  = "./modules/resource-group"
  resource_group_name     = var.resource_group_name_hub
  resource_group_location = var.location
  tags                    = {
    env = var.resource_postfix
  }
}

module "spoke_resource_group" {
  source = "./modules/resource-group"
  resource_group_name     = var.resource_group_name_spoke
  resource_group_location = var.location
  tags                    = {
    env ="${var.resource_prefix}${var.resource_postfix}"
  }
}

module "hub_network" {
  source              = "./modules/vnet"
  resource_group_name = module.hub_resource_group.resource_group_name
  location            = var.location
  vnet_name           = "${var.resource_prefix}VNET-HUB${var.resource_postfix}"
  address_space       = var.hub_address_space
  subnets = {
    BastionSubnet = {
      name             = var.name_subnet_bastion
      address_prefixes = var.hub_bastion_subnet_address_prefix //(64 adresse ip disponible)
    },
    GatewaySubnet = {
      name             = var.name_subnet_gateway
      address_prefixes = var.hub_gateway_subnet_address_prefix //(64-95 32 adresse disponible)
    },
  }
}

module "spoke_network" {
  source              = "./modules/vnet"
  resource_group_name = module.spoke_resource_group.resource_group_name
  location            = var.location
  vnet_name           = "${var.resource_prefix}VNET-SPOKE${var.resource_postfix}"
  address_space       = var.spoke_vnet_address_space //(65536)
  subnets = {
    aks-subnet = {
      name             = var.name_subnet_aks
      address_prefixes = var.aks_subnet_address_prefix //(1024)
    },
    JumpBox-subnet = {
      name             = var.name_subnet_JumpBox
      address_prefixes = var.jumbox_subnet_address_prefix //(256)
    },
    Azure-App-gateway-subnet = {
      name             = var.name_subnet_app_gateway
      address_prefixes = var.app_gateway_subnet_address_prefix //(256)
    },
    Private-link-subnet = {
      name             = var.name_subnet_privite_link
      address_prefixes = var.Private_link_subnet_address_prefix //(16)
    },
    MySQL-subnet = {
      name             = var.name_subnet_mysql
      address_prefixes = var.Mysql_subnet_address_prefix //(16)
      delegations = [
        {
          name = "Microsoft.DBforMySQL/flexibleServers"
          service_delegation = {
            name = "Microsoft.DBforMySQL/flexibleServers"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/join/action",
            ]
          }
        }
      ]
    },
  }
}

module "vnet_peering" {
  source              = "./modules/peering"
  vnet_1_name         = "${var.resource_prefix}VNET-HUB${var.resource_postfix}"
  vnet_1_id           = module.hub_network.vnet_id
  vnet_1_rg           = module.hub_resource_group.resource_group_name
  vnet_2_name         = "${var.resource_prefix}VNET-SPOKE${var.resource_postfix}"
  vnet_2_id           = module.spoke_network.vnet_id
  vnet_2_rg           = module.spoke_resource_group.resource_group_name
  peering_name_1_to_2 = "${var.hub_vnet_name}To-${var.spoke_vnet_name}"
  peering_name_2_to_1 = "${var.spoke_vnet_name}To-${var.hub_vnet_name}"
  allow_virtual_network_access_1 = var.allow_virtual_network_access_hub
  allow_forwarded_traffic_1      = var.allow_forwarded_traffic_hub
  allow_gateway_transit_1        = var.allow_gateway_transit_hub
  use_remote_gateways_1          = var.use_remote_gateways_hub
  allow_virtual_network_access_2 = var.allow_virtual_network_access_spoke
  allow_forwarded_traffic_2      = var.allow_forwarded_traffic_spoke
  allow_gateway_transit_2        = var.allow_gateway_transit_spoke
  use_remote_gateways_2          = var.use_remote_gateways_spoke
}


module "application_gateway" {
  source                                = "./Modules/application_gateway"
  name                                  = "${var.resource_prefix}APP-GATEWAY${var.resource_postfix}"
  resource_group_name                   = module.spoke_resource_group.resource_group_name
  location                              = var.location
  tags                    = {
    env = var.resource_postfix
  }
  sku                                   = { size = var.sku_size , tier = var.sku_tier_waf}
  subnet_id                             = module.spoke_network.subnet_ids[var.name_subnet_app_gateway]
  autoscale_configuration               = var.autoscale_configuration
  frontend_ip_configuration             = { public_ip_address_id = azurerm_public_ip.app-gw-pip01.id
                                           private_ip_address   = var.private_ip_address_frontend_ip_conf_appgw,
                                           private_ip_address_allocation = var.private_ip_address_allocation_frontend_ip_conf_appgw  }

  backend_address_pools = [
   { name =  var.name_backend_address_pools}
  ]

  http_listeners        = [{ name = var.name_http_listeners, 
                             frontend_ip_configuration = var.frontend_ip_configuration , 
                             port = var.http_listeners_port,
                             protocol = var.http_listeners_protocol }]

  backend_http_settings = [{ name = var.backend_http_settings_name , 
                             port = var.backend_http_settings_port, 
                             protocol = var.backend_http_settings_protocol,
                             path = var.backend_http_settings_path,
                             request_timeout = 20 }]
  request_routing_rules = [
    {
      name                       = var.request_routing_rules_name
      http_listener_name         = var.name_http_listeners
      backend_address_pool_name  = var.name_backend_address_pools
      backend_http_settings_name = var.backend_http_settings_name
    }
  ]
  waf_configuration = {
    enabled          = var.waf_conf_enabled
    firewall_mode    = var.waf_conf_firewall_mode
    rule_set_version = var.waf_conf_rule_set_version
  }
}

resource "azurerm_public_ip" "app-gw-pip01" {
  name                = "app-gw-pip01"
  resource_group_name = module.spoke_resource_group.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}
/*
module "network_security_group_web" {
  source              = "./Modules/network_security_group"
  name                = "${var.resource_prefix}NGS${var.resource_postfix}"
  resource_group_name = module.spoke_resource_group.resource_group_name
  location            = var.location
  inbound_rules = [
    {
      name                       = "web"
      priority                   = 100
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      source_port_range          = "*"
      destination_port_ranges    = ["65200-65535","443"]
    }
  ]
  subnet_id                 =  module.spoke_network.subnet_ids[var.name_subnet_app_gateway]
  network_security_group_id =  module.network_security_group_web.nsg_id
}
*/

module "container_registry" {
  source                       = "./modules/container_reg"
  name                         = "${var.resource_prefix_spec}ACR${var.resource_postfix_spec}"
  resource_group_name          = module.spoke_resource_group.resource_group_name
  location                     = var.location
  sku                          = var.acr_sku
  georeplication_locations     = var.acr_georeplication_locations
  tags                    = {
    env = var.resource_postfix
  }
}

//Attaching a Container Registry to a Kubernetes Cluster
resource "azurerm_role_assignment" "acr_pull" {
  role_definition_name = "AcrPull"
  scope                = module.container_registry.id
  principal_id         = module.aks_cluster.kubelet_identity_object_id
  skip_service_principal_aad_check = true
}

module "storage_account" {
  source                      = "./modules/storage_account"
  name                        = "${local.storage_account_prefix}${random_string.storage_account_suffix.result}"
  location                    = var.location
  resource_group_name         = module.spoke_resource_group.resource_group_name
  account_kind                = var.storage_account_kind
  account_tier                = var.storage_account_tier
  replication_type            = var.storage_account_replication_type
  tags                    = {
    env = var.resource_postfix
  }
}

module "aks_cluster" {
  source                                   = "./modules/aks"
  name                                     = "${var.resource_prefix}AKS${var.resource_postfix}"
  location                                 = var.location
  resource_group_name                      = module.spoke_resource_group.resource_group_name
  kubernetes_version                       = var.kubernetes_version
  private_cluster_enabled                  = var.private_cluster_enabled
  dns_prefix                               = lower("${var.resource_prefix}AKS${var.resource_postfix}")
  vnet_subnet_id                           = module.spoke_network.subnet_ids[var.name_subnet_aks]
  default_node_pool_availability_zones     = var.default_node_pool_availability_zones
  default_node_pool_enable_auto_scaling    = var.default_node_pool_enable_auto_scaling
  node_resource_group                      = var.node_resource_group
  network_plugin                           = var.network_plugin
  tenant_id                                = data.azurerm_client_config.current.tenant_id
  admin_group_object_ids                   = var.admin_group_object_ids
  azure_rbac_enabled                       = var.azure_rbac_enabled
  appgw-id                                 = module.application_gateway.appgw-id
  tags                    = {
    env = var.resource_postfix
  }
}


/*
module "nsg-Inbound" {
  source                   = "./modules/network_security_group"
  name                     = "${var.resource_prefix}NGSInbound${var.resource_postfix}"
  resource_group_name      = module.spoke_resource_group.resource_group_name
  location                 = var.location
  inbound_rules = [
    {
      name                       = "AllowVnetInbound"
      priority                   = "4096"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
  ]
  subnet_id                      =  module.spoke_network.subnet_ids[var.name_subnet_app_gateway]
  network_security_group_id      =  module.nsg-Inbound.nsg_id
}

module "nsg-Inbound-Deny" {
  source                   = "./modules/network_security_group"
  name                     = "${var.resource_prefix}NGSInboundDeny${var.resource_postfix}"
  resource_group_name      = module.spoke_resource_group.resource_group_name
  location                 = var.location
  inbound_rules = [
    {
      name                       = "DenyALLInbound"
      priority                   = "4095"
      direction                  = "Inbound"
      access                     = "Deny"
      source_port_range          = "*"
      destination_port_range     = "*"
      protocol                   = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
  subnet_id                      =  module.spoke_network.subnet_ids[var.name_subnet_app_gateway]
  network_security_group_id      =  module.nsg-Inbound-Deny.nsg_id
}
*/
module "gateway_vpn" {
  source                = "./Modules/gateway_VPN"
  name                  = "${var.resource_prefix}GATEWAY-VPN${var.resource_postfix}"
  location              = var.location
  resource_group_name   = module.hub_resource_group.resource_group_name
  subnet_id             = module.hub_network.subnet_ids[var.name_subnet_gateway]
  tags                    = {
    env = var.resource_postfix
  }
}
/*
module "bastion_host" {
  source                       = "./modules/bastion_host"
  name                         = "${var.resource_prefix}BASTION${var.resource_postfix}"
  location                     = var.location
  resource_group_name          = module.hub_resource_group.resource_group_name
  subnet_id                    = module.hub_network.subnet_ids[var.name_subnet_bastion]
  tags                    = {
    env = var.resource_postfix
  }
}*/

module "key_vault" {
  source                          = "./modules/key_vault"
  name                            = "${var.resource_prefix}KEY-VAULT${var.resource_postfix}"
  location                        = var.location
  resource_group_name             = module.spoke_resource_group.resource_group_name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = var.key_vault_sku_name
  purge_protection_enabled        = var.key_vault_purge_protection_enabled
  soft_delete_retention_days      = var.key_vault_soft_delete_retention_days
  bypass                          = var.key_vault_bypass
  default_action                  = var.key_vault_default_action
  tags                    = {
    env = var.resource_postfix
  }
}

module "blob_private_endpoint" {
  source                         = "./modules/private_link"
  name                           = "${title(module.storage_account.name)}PrivateEndpoint"
  location                       = var.location
  resource_group_name            = module.spoke_resource_group.resource_group_name
  subnet_id                      = module.spoke_network.subnet_ids[var.name_subnet_privite_link]
  private_connection_resource_id = module.storage_account.id
  is_manual_connection           = false
  subresource_name               = "blob"
  tags                    = {
    env = var.resource_postfix
  }
} 

module "acr_private_endpoint" {
  source                         = "./modules/private_link"
  name                           = "${module.container_registry.name}PrivateEndpoint"
  location                       = var.location
  resource_group_name            = module.spoke_resource_group.resource_group_name
  subnet_id                      = module.spoke_network.subnet_ids[var.name_subnet_privite_link]
  private_connection_resource_id = module.container_registry.id
  is_manual_connection           = false
  subresource_name               = "registry"
  tags                    = {
    env = var.resource_postfix
  }
} 

module "key_vault_private_endpoint" {
  source                         = "./modules/private_link"
  name                           = "${title(module.key_vault.name)}PrivateEndpoint"
  location                       = var.location
  resource_group_name            = module.spoke_resource_group.resource_group_name
  subnet_id                      = module.spoke_network.subnet_ids[var.name_subnet_privite_link]
  private_connection_resource_id = module.key_vault.id
  is_manual_connection           = false
  subresource_name               = "vault"
  tags                    = {
    env = var.resource_postfix
  }
}

module "mysql-db" {
  source                = "./Modules/mysql"
  mysql_name            = "${var.resource_prefix_spec}-mysql-${var.resource_postfix_spec}"
  resource_group_name   = module.spoke_resource_group.resource_group_name
  location              = var.location
  delegated_subnet_id   = module.spoke_network.subnet_ids[var.name_subnet_mysql]
  mysql_version         = var.mysql_version
  mysql_server_name     = var.mysql_server_name
  private_dns           = var.private_dns//
  admin_username        = var.admin_username_mysql
  admin_password        = var.admin_password_mysql
  sku_name              = var.sku_name_mysql
  auto_grow_enabled     = var.auto_grow_enabled//
  iops                  = var.iops//
  size_gb               = var.size_gb
  tags                    = {
    env = var.resource_postfix
  }
}

module "virtual_machine" {
  source              = "./modules/virtual_machine"
  name                = "${var.resource_prefix}VM-JUMP${var.resource_postfix}"
  size                = var.vm_size
  location            = var.location
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  resource_group_name = module.spoke_resource_group.resource_group_name
  subnet_id           = module.spoke_network.subnet_ids[var.name_subnet_JumpBox]
  tags                    = {
    env = var.resource_postfix
  }
}






