resource "azurerm_storage_account" "k8s_demo_resources_tf_state_storage_account" {
  name                      = "k8sdemoresourcestfstate"
  location                  = azurerm_resource_group.k8s_demo_resources.location
  resource_group_name       = azurerm_resource_group.k8s_demo_resources.name
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  access_tier               = "Hot"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"

  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_storage_container" "k8s_demo_resources_tf_state_storage_account_container_01" {
  name                  = "terraform-states"
  storage_account_name  = azurerm_storage_account.k8s_demo_resources_tf_state_storage_account.name
  container_access_type = "private"
}