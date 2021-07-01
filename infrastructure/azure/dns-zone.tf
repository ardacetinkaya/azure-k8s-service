resource "azurerm_dns_zone" "k8s_cluster_dns_zone_public" {
  name                = var.domain
  resource_group_name = azurerm_resource_group.k8s_demo_resources.name
}