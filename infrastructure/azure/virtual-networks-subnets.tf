resource "azurerm_subnet" "k8s_cluster_01_network_01_subnet_01" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.k8s_demo_resources.name
  virtual_network_name = azurerm_virtual_network.k8s_cluster_01_network_01.name
  address_prefixes     = ["10.240.0.0/16"]
}