module "resource_group" {

    source              = "../../modules/resource_group"  
    resource_group_name = "${local.resource_group_name}"
    location            = "${var.location}" 
    tags                = "${merge(var.default_tags,tomap({type="resource_group"}))}"
}


module "network" {
  source              = "../../modules/network"
  resource_group_name = "${var.vnet_resource_group_name}"
  location            = "${var.location}"
  tags                = "${var.tags}"
  route_table_id       = "${data.azurerm_route_table.route_table.id}"
  vnet_name           = "${var.vnet_name}"
  delegation          =  true
  add_endpoint        =  true
  subnets = [
    {
      name   = "${local.subnet_name}-cda"
      prefix = "${var.cda_subnet_prefix}"
      service_endpoint = "Microsoft.Storage"
    }
  ]
}


module "key_vault" {
  providers = {
    azurerm.dns =  azurerm.dns
  } 
  source                = "../../modules/key-vault"
  azure_key_vault_name  = "${local.azure_key_vault_name}"
  location              = "${var.location}"
  resource_group_name   = "${module.resource_group.resource_group_name}"
  private_endpoint_subnet = "${module.private_link.id}"
  mi_principal_id       = "${module.managed_identity.principal_id}"
  log_analytics_workspace_id = "${data.azurerm_log_analytics_workspace.loganalytics_ws.id}"
  tags                  = "${merge(var.default_tags,tomap({type="Key_vault"}))}"
  depends_on = [
    module.resource_group,module.managed_identity,
  ]
}


module "sql-server" {
  source = "../../modules/mssql-server"
  for_each = "${var.sql_db}"
  sql_server_name = "${local.sql_server_name}-${each.value.server_name_suffix}"
  resource_group_name = "${module.resource_group.resource_group_name}"
  database_name = "${each.value.db}"
  location = "${var.location}"
  sql_server_version = "${var.sql_server_version}"
  sku_name = "${each.value.sku_name}"
  database_size = "${each.value.database_size}"
}

module "virtual_machine" {
  source              = "../../modules/virtual-machine"
  server_name         = "${local.vm_name}-adf"
  location            = "${var.location}"
  vnet_resource_group_name = "${var.vnet_resource_group_name}"
  resource_group_name = "${module.resource_group.resource_group_name}"  
  vm_size             = "${var.vm_size}"
  tags                = "${merge(var.default_tags,tomap({type="application-server"}))}"
  subnet_name         = "${local.subnet_name}-vm"
  subnet_prefix       = "${var.vm_subnet_prefix}"
  vnet_name           = "${var.vnet_name}"
  route_table_id       = "${data.azurerm_route_table.route_table.id}"
}
module "virtual_machine" {
  source              = "../../modules/virtual-machine"
  server_name         = "${local.vm_name}-adf"
  location            = "${var.location}"
  vnet_resource_group_name = "${var.vnet_resource_group_name}"
  resource_group_name = "${module.resource_group.resource_group_name}"  
  vm_size             = "${var.vm_size}"
  tags                = "${merge(var.default_tags,tomap({type="application-server"}))}"
  subnet_name         = "${local.subnet_name}-vm"
  subnet_prefix       = "${var.vm_subnet_prefix}"
  vnet_name           = "${var.vnet_name}"
  route_table_id       = "${data.azurerm_route_table.route_table.id}"
 
}

module "load_balancer" {
  source              = "../../modules/load_balancer"
  lb_name             = "${local.lb_name}-adf"
  location            = "${var.location}"
  prtlnk_service_name = "${local.prtlnk_service_name}"
  resource_group_name = "${module.resource_group.resource_group_name}"  
  tags                = "${merge(var.default_tags,tomap({type="application-server"}))}"
  subnet_name        = "${local.subnet_name}-vm"
  vnet_name           = "${var.vnet_name}"
  vnet_resource_group_name  = "${var.vnet_resource_group_name}"
  private_endpoint_subnet   = "${module.private_link.id}"
  lb_rules            = "${var.lb_rules}"
  pls_subnet_name         = "${local.subnet_name}-pls"
  pls_subnet_prefix       = "${var.pls_subnet_prefix}"
  server_name         = "${local.vm_name}-adf"
  vm_required_in_zone2  = true
  log_analytics_workspace_id = "${data.azurerm_log_analytics_workspace.loganalytics_ws.id}"
  depends_on = [
    module.resource_group, module.virtual_machine,
  ]
}

