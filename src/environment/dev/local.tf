locals {
  resource_group_name="rg-${var.PROD_NONPROD}-${var.SHORT_LOCATION}-${var.TARGET_ENVIRONMENT}-${var.Environment}"

  sql_server_name = "sql-${var.PROD_NONPROD}-${var.SHORT_LOCATION}-${var.TARGET_ENVIRONMENT}-${var.Environment}"
  
  azure_key_vault_name = "kv-${var.PROD_NONPROD}-${var.SHORT_LOCATION}-${var.TARGET_ENVIRONMENT}-${var.Environment}"

  subnet_name = "sbnt-${var.PROD_NONPROD}-${var.SHORT_LOCATION}-${var.TARGET_ENVIRONMENT}-${var.Environment}"

  lb_name = "lb-${var.PROD_NONPROD}-${var.SHORT_LOCATION}-${var.TARGET_ENVIRONMENT}-${var.Environment}"

  address_space = {"10.126.66.0/24"}

  pe_subnet_address = {"10.126.66.0/26"}
  
  tags = {
    Environment         = var.target_environment
    "Business Owner"    = "ABC"
    "Technical Owner"   = "ABC"
    "Cost Owner"        = "ABC"
    "Cost Centre"       = "ABC"
    "Business Function" = "ABC"
    Repository          = var.build_repository_name
  }

}