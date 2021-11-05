resource "azurerm_key_vault_access_policy" "k8s_kv_access_policy" {
    key_vault_id = azurerm_key_vault.k8s-kv.id
    tenant_id    = data.azurerm_client_config.current.tenant_id
    object_id    = var.cluster_managed_user_client_id

    key_permissions = [
        "Get",
    ]

    secret_permissions = [
        "Get",
    ]

    certificate_permissions = [
        "Get",
    ]
}