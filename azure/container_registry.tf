resource "azurerm_container_registry" "acr" {
  name                = "biber"
  resource_group_name = azurerm_resource_group.infra.name
  location            = azurerm_resource_group.infra.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_role_assignment" "acr_aks_rule" {
  principal_id                     = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

resource "azurerm_container_registry_scope_map" "acr" {
  name                    = "biber-scope-map"
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = azurerm_resource_group.infra.name
  actions = [
    "repositories/biber/content/read",
    "repositories/biber/content/write",
    "repositories/biber/content/delete",
    "repositories/biber/content/metadata/read",
    "repositories/biber/content/metadata/write",
  ]
}

resource "azurerm_container_registry_token" "biber_token" {
  name                    = "biber-token"
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = azurerm_resource_group.infra.name
  scope_map_id            = azurerm_container_registry_scope_map.acr.id
}

resource "azurerm_container_registry_token_password" "biber_password" {
  container_registry_token_id = azurerm_container_registry_token.biber_token.id

  password1 {
  }
}
