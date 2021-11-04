resource "azurerm_key_vault" "k8s-kv" {
    name                        = "aksk8skeyvault"
    location                    = azurerm_resource_group.k8s_demo_resources.location
    resource_group_name         = azurerm_resource_group.k8s_demo_resources.name
    tenant_id                   = data.azurerm_client_config.current.tenant_id
    soft_delete_retention_days  = 7
    purge_protection_enabled    = false
    sku_name                    = "standard"
}