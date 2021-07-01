resource "azurerm_dns_a_record" "k8s_cluster_dns_zone_a_record" {
  name                = "www"
  zone_name           = azurerm_dns_zone.k8s_cluster_dns_zone_public.name
  resource_group_name = azurerm_resource_group.k8s_demo_resources.name
  ttl                 = 300
  records             = [var.nginx_external_ip]
}