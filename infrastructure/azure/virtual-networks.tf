resource "azurerm_virtual_network" "k8s_cluster_01_network_01" {
  name                = "k8s-cluster-01-network-01"
  address_space       = ["10.0.0.0/8"]
  location            = azurerm_resource_group.k8s_demo_resources.location
  resource_group_name = azurerm_resource_group.k8s_demo_resources.name
}