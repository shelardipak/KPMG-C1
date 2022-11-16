
location= "UK South"
Environment="dev"
pvtlnk_subnet_prefix = "10.126.149.0/25"
shared_pvtlnk_subnet_prefix = "10.126.146.0/27"
vnet_name = "vnet-dev-network"
vnet_resource_group_name = "rg-dev-network"
route_table_name = "rt-dev-network"
# SQL database
sql_server_version = "12.0"
sql_db = {
  "abc" = {
    db = [ "ABC" ]
    server_name_suffix = "ABC"
    sku_name = "BC_Gen5_8"
    database_size = "1024"
  },
  "PQR" = {
    db = [ "PQR" ]
    server_name_suffix = "PQR"
    sku_name = "BC_Gen5_8"
    database_size = "1024"
  }
}

#VM
disk_size = "50"
vm_size = "Standard_B2s"
vm_subnet_prefix = "10.126.150.208/28"
pls_subnet_prefix = "10.126.150.224/28"
lb_rules = {
  "rule1" = {
    name = "rule1" 
    frontendport = 445
    backendport = 446
  }
}

