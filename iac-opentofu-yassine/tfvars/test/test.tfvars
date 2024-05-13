resource_group_name_hub = "TEST-RG-hub"
resource_group_name_spoke = "TEST-RG-SPOKE"


location = "northeurope"
hub_vnet_name = "TEST-HUB-VNET"
hub_address_space = ["10.200.0.0/24"]
hub_bastion_subnet_address_prefix = ["10.200.0.0/26"]
hub_gateway_subnet_address_prefix = ["10.200.0.64/27"]

spoke_vnet_name = "TEST-SPOKE"
spoke_vnet_address_space = ["10.240.0.0/16"]
aks_subnet_address_prefix = ["10.240.0.0/22"]
jumbox_subnet_address_prefix = ["10.240.4.0/28"]
app_gateway_subnet_address_prefix = ["10.240.5.0/24"]
Private_link_subnet_address_prefix = ["10.240.4.32/28"]
Mysql_subnet_address_prefix = ["10.240.6.0/24"]

resource_prefix         = "SOCLE-"
resource_postfix        = "-TEST"
resource_prefix_spec = "socle"
resource_postfix_spec = "test"




