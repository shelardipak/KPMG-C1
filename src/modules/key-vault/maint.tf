resource "azurerm_key_vault" "azure-key-vault" {
  name                        = "${var.azure_key_vault_name}"
  location                    = "${var.location}"
  resource_group_name         = "${var.resource_group_name}"
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true

  sku_name = "standard"

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions = [
      "get", "list",
    ]
    secret_permissions = [
      "get", "backup", "delete", "list", "purge", "recover", "restore", "set",
    ]
    storage_permissions = [
      "get","list",
    ]
    certificate_permissions = [
      "get", "list",
    ]
  }
  
  tags = "${var.tags}"
  lifecycle {
    ignore_changes = [
      access_policy,
    ]
  }
}