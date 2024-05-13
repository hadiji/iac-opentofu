resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                              = var.name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  dns_prefix                        = var.dns_prefix
  kubernetes_version                = var.kubernetes_version
  private_cluster_enabled           = var.private_cluster_enabled
  automatic_channel_upgrade         = var.automatic_channel_upgrade
  sku_tier                          = var.sku_tier
  node_resource_group               = var.node_resource_group
  image_cleaner_enabled             = var.image_cleaner_enabled
  azure_policy_enabled              = var.azure_policy_enabled

  default_node_pool {
    name                    = var.default_node_pool_name
    vm_size                 = var.default_node_pool_vm_size
    vnet_subnet_id          = var.vnet_subnet_id
    pod_subnet_id           = var.pod_subnet_id
    zones                   = var.default_node_pool_availability_zones
    node_labels             = var.default_node_pool_node_labels
    node_taints             = var.default_node_pool_node_taints
    enable_auto_scaling     = var.default_node_pool_enable_auto_scaling
    enable_node_public_ip   = var.default_node_pool_enable_node_public_ip
    max_pods                = var.default_node_pool_max_pods
    max_count               = var.default_node_pool_max_count
    min_count               = var.default_node_pool_min_count
    node_count              = var.default_node_pool_node_count
    tags                    = var.tags
  }

  network_profile {
    network_plugin = var.network_plugin
    network_policy = var.network_policy
  }

  azure_active_directory_role_based_access_control {
    managed                    = true
    tenant_id                  = var.tenant_id
    admin_group_object_ids     = var.admin_group_object_ids
    azure_rbac_enabled         = var.azure_rbac_enabled
  }

  identity {
    type = "SystemAssigned"
  }
  //Exactly one of gateway_id, subnet_id or subnet_cidr must be specified.
  ingress_application_gateway {
      gateway_id = var.appgw-id
  }
 //Aspect sécurité pour les secrets et les API.
  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }
}