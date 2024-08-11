resource "azurerm_role_assignment" "network_contributor_rg" {
  principal_id   = azurerm_kubernetes_cluster.cluster.identity[0].principal_id
  role_definition_name = "Network Contributor"
  scope          = azurerm_resource_group.infra.id
}

resource "azurerm_role_assignment" "network_contributor_public_ip_v4" {
  principal_id   = azurerm_kubernetes_cluster.cluster.identity[0].principal_id
  role_definition_name = "Network Contributor"
  scope          = azurerm_public_ip.nginx_ip_v4.id
}

resource "azurerm_role_assignment" "network_contributor_public_ip_v6" {
  principal_id   = azurerm_kubernetes_cluster.cluster.identity[0].principal_id
  role_definition_name = "Network Contributor"
  scope          = azurerm_public_ip.nginx_ip_v6.id
}
