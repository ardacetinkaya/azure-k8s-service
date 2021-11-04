resource "azurerm_container_registry" "container_registery_01" {
  name                     = "k8simagesregistery"
  resource_group_name      = azurerm_resource_group.k8s_demo_resources.name
  location                 = azurerm_resource_group.k8s_demo_resources.location
  sku                      = "Basic"
  admin_enabled            = true
}