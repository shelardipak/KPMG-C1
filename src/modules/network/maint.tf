
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.prod_nonprod}-${var.short_location}-${var.target_environment}-${var.identifier}"
  location = var.location
  tags     = merge(local.common_tags)
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.prod_nonprod}-${var.short_location}-${var.target_environment}-${var.identifier}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = local.address_space[var.target_environment]
  dns_servers         = ["10.126.0.104", "10.126.0.105"]
  tags                = merge(local.common_tags)
}

resource "azurerm_subnet" "pe" {
  name                                           = "sbnt-${var.prod_nonprod}-${var.short_location}-${var.target_environment}-prvlnk"
  resource_group_name                            = azurerm_resource_group.main.name
  virtual_network_name                           = azurerm_virtual_network.main.name
  address_prefixes                               = [local.pe_subnet_address[var.target_environment]]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet_route_table_association" "main" {
  subnet_id      = azurerm_subnet.pe.id
  route_table_id = azurerm_route_table.prvlnks.id
}

resource "azurerm_route_table" "main" {
  name                          = "rt-${var.prod_nonprod}-${var.short_location}-${var.target_environment}-${var.identifier}"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  disable_bgp_route_propagation = true
  tags                          = merge(local.common_tags)

  route {
    name                   = "route-to-on-prem"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.126.0.22"
  }
  route{
    name                   = "route-to-internet"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.126.0.22"
  }
 
}
