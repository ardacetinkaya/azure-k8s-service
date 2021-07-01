/*
data "azurerm_kubernetes_cluster" "k8s_cluster_01" {
  name                = azurerm_kubernetes_cluster.k8s_cluster_01.name
  resource_group_name = azurerm_resource_group.k8s_demo_resources.name
}

data "azuread_service_principal" "k8s_cluster_01_principal" {
  application_id = data.azurerm_kubernetes_cluster.k8s_cluster_01.kubelet_identity[0].client_id
}

resource "azurerm_role_assignment" "acrpull_role" {
  scope                            = azurerm_container_registry.container_registery_01.id
  role_definition_name             = "AcrPull"
  principal_id                     = data.azuread_service_principal.k8s_cluster_01_principal.id
  skip_service_principal_aad_check = true
}
*/