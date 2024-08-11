resource "azurerm_log_analytics_workspace" "analytics" {
  name                = "kubernetes-analytics"
  location            = azurerm_resource_group.infra.location
  resource_group_name = azurerm_resource_group.infra.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_data_collection_rule" "aks" {
  name                = azurerm_kubernetes_cluster.cluster.name
  resource_group_name = azurerm_resource_group.infra.name
  location            = azurerm_resource_group.infra.location

  destinations {
    log_analytics {
      name                  = "ciworkspace"
      workspace_resource_id = azurerm_log_analytics_workspace.analytics.id
    }
  }

  data_flow {
    streams = ["Microsoft-ContainerInsights-Group-Default"]
    destinations = ["ciworkspace"]
  }

  data_sources {
    extension {
      name           = "ContainerInsightsExtension"
      streams = ["Microsoft-ContainerInsights-Group-Default"]
      extension_name = "ContainerInsights"
      extension_json = jsonencode({
        dataCollectionSettings = {
          enableContainerLogV2   = true
          interval               = "5m"
          namespaceFilteringMode = "Exclude"
          namespaces = [
            "kube-system",
            "gatekeeper-system",
            "azure-arc"
          ]
        }
      })
    }
  }
}

resource "azurerm_monitor_data_collection_rule_association" "aks" {
  name                    = azurerm_kubernetes_cluster.cluster.name
  target_resource_id      = azurerm_kubernetes_cluster.cluster.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.aks.id
}
