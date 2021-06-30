
resource "azurerm_user_assigned_identity" "k8s_cluster_01_identity" {
  location            = azurerm_resource_group.k8s_demo_resources.location
  resource_group_name = azurerm_resource_group.k8s_demo_resources.name
  name                = "k8s-identity"
}

resource "azurerm_kubernetes_cluster" "k8s_cluster_01" {
  name                = "k8s-cluster-01"
  location            = azurerm_resource_group.k8s_demo_resources.location
  resource_group_name = azurerm_resource_group.k8s_demo_resources.name
  dns_prefix          = "k8s-dns" 

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
    # user_assigned_identity_id = azurerm_user_assigned_identity.k8s_cluster_01_identity.id
  }
}