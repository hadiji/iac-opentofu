resource "azurerm_virtual_network_peering" "peering" {
  name                         = var.peering_name_1_to_2
  resource_group_name          = var.vnet_1_rg
  virtual_network_name         = var.vnet_1_name
  remote_virtual_network_id    = var.vnet_2_id
  allow_virtual_network_access = var.allow_virtual_network_access_1
  allow_forwarded_traffic      = var.allow_forwarded_traffic_1
  allow_gateway_transit        = var.allow_gateway_transit_1
  use_remote_gateways          = var.use_remote_gateways_1
}

resource "azurerm_virtual_network_peering" "peering-back" {
  name                         = var.peering_name_2_to_1
  resource_group_name          = var.vnet_2_rg
  virtual_network_name         = var.vnet_2_name
  remote_virtual_network_id    = var.vnet_1_id
  allow_virtual_network_access = var.allow_virtual_network_access_2
  allow_forwarded_traffic      = var.allow_forwarded_traffic_2
  allow_gateway_transit        = var.allow_gateway_transit_2
  use_remote_gateways          = var.use_remote_gateways_2
}


