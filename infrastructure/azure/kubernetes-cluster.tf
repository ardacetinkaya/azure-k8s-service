
resource "azurerm_kubernetes_cluster" "k8s_cluster_01" {
  name                = "k8s-cluster-01"
  location            = azurerm_resource_group.k8s_demo_resources.location
  resource_group_name = azurerm_resource_group.k8s_demo_resources.name
  dns_prefix          = "k8s-dns" 

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_B2s"
    vnet_subnet_id = azurerm_subnet.k8s_cluster_01_network_01_subnet_01.id
  }

  network_profile {
    network_plugin      = "azure"
    load_balancer_sku   = "standard"
    service_cidr        = "10.0.0.0/16"
    docker_bridge_cidr  = "172.17.0.1/16"
    dns_service_ip      = "10.0.0.10"
  }

  identity {
    type = "SystemAssigned"
  }
}