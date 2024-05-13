data "azurerm_client_config" "current" {
}

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.name}PublicIp-VPN"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.allocation_method
  sku = "Standard"
}


resource "azurerm_virtual_network_gateway" "gateway_vpn" {
  name                = var.gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  type     = "Vpn"
  vpn_type = var.vpn_type

  active_active = false
  enable_bgp    = false
  sku           = var.sku

  ip_configuration {
    name                          = var.name_ip_config
    public_ip_address_id          = azurerm_public_ip.public_ip.id
    private_ip_address_allocation = var.private_ip_address_allocation
    subnet_id                     = var.subnet_id
  }

  vpn_client_configuration {
    address_space = var.address_space
    vpn_client_protocols = ["OpenVPN"]
    aad_tenant             = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}"
    aad_audience           = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
    aad_issuer             = "https://sts.windows.net/${data.azurerm_client_config.current.tenant_id}/"
  }
}