
data "azurerm_subnet" "vmsubnet" {
  name                 = "${var.subnet_name}"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name = "${var.vnet_resource_group_name}"
}

data "azurerm_network_interface" "az_nic_1" {
  name  = "${var.server_name}-nic"
  resource_group_name = "${var.resource_group_name}"

}



resource "azurerm_subnet" "plssubnet" {
  resource_group_name  = "${var.vnet_resource_group_name}"
  name                 = "${var.pls_subnet_name}"
  virtual_network_name = "${var.vnet_name}"
  enforce_private_link_service_network_policies = true
  address_prefixes     =  ["${var.pls_subnet_prefix}"]
}

resource "azurerm_lb" "internal_lb" {
  name                = "${var.lb_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"

  frontend_ip_configuration {
    name      = "PrivateIP"
    subnet_id = "${data.azurerm_subnet.vmsubnet.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "adf_be_pool" {
  loadbalancer_id = azurerm_lb.internal_lb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "internal_lb_probe" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = azurerm_lb.internal_lb.id
  name                = "ssh-running-probe"
  port                = 22
  interval_in_seconds = 15
}

resource "azurerm_lb_rule" "internal_lb_rule" {
  for_each                       = "${var.lb_rules}"
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = azurerm_lb.internal_lb.id
  name                           = "${each.value.name}"
  protocol                       = "Tcp"
  frontend_port                  = "${each.value.frontendport}"
  backend_port                   = "${each.value.backendport}"
  frontend_ip_configuration_name = "PrivateIP1"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.adf_be_pool.id
  probe_id                       = azurerm_lb_probe.internal_lb_probe.id 
}


resource "azurerm_network_interface_backend_address_pool_association" "adf_be_2" {
  count               = "${var.vm_required_in_zone2 == true ? 1 : 0}"
  network_interface_id    = "${data.azurerm_network_interface.az_nic_2[0].id}"
  ip_configuration_name   = "ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.adf_be_pool.id

  depends_on = [
    #azurerm_virtual_machine_extension.ip_config
  ]
}


resource "azurerm_public_ip" "example" {
  name                = "PublicIPForLB"
  location            = "West US"
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "frontend_lb" {
  name                = "${var.lb_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"

frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

resource "azurerm_lb_backend_address_pool" "adf_be_pool" {
  loadbalancer_id = azurerm_lb.internal_lb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "internal_lb_probe" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = azurerm_lb.internal_lb.id
  name                = "ssh-running-probe"
  port                = 22
  interval_in_seconds = 15
}

resource "azurerm_lb_rule" "internal_lb_rule" {
  for_each                       = "${var.lb_rules}"
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = azurerm_lb.internal_lb.id
  name                           = "${each.value.name}"
  protocol                       = "Tcp"
  frontend_port                  = "${each.value.frontendport}"
  backend_port                   = "${each.value.backendport}"
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.adf_be_pool.id
  probe_id                       = azurerm_lb_probe.internal_lb_probe.id 
}


resource "azurerm_network_interface_backend_address_pool_association" "adf_be_2" {
  count               = "${var.vm_required_in_zone2 == true ? 1 : 0}"
  network_interface_id    = "${data.azurerm_network_interface.az_nic_2[0].id}"
  ip_configuration_name   = "ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.adf_be_pool.id

  depends_on = [
    #azurerm_virtual_machine_extension.ip_config
  ]
}


