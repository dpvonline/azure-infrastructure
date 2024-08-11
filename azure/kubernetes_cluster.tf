resource "azurerm_kubernetes_cluster" "cluster" {
  name                             = "Kubernetes-Cluster"
  location                         = var.REGION
  resource_group_name              = azurerm_resource_group.infra.name
  dns_prefix                       = "k8s"
  private_cluster_enabled          = false
  sku_tier                         = "Free"
  kubernetes_version               = "1.32.5"
  automatic_upgrade_channel        = "stable"
  http_application_routing_enabled = false


  default_node_pool {
    name                         = "system"
    node_count                   = 1
    vm_size                      = var.BASE_VM_SIZE
    vnet_subnet_id               = azurerm_subnet.internal.id
    auto_scaling_enabled = false
    #     enable_host_encryption = true
    os_sku                       = "AzureLinux"
    ultra_ssd_enabled            = false
    zones = ["1",]
    os_disk_size_gb              = 64
    os_disk_type                 = "Managed"
    only_critical_addons_enabled = false
    temporary_name_for_rotation  = "test"
    node_public_ip_enabled       = false

    upgrade_settings {
      max_surge = "10%"
      drain_timeout_in_minutes = 5
      node_soak_duration_in_minutes = 0
    }
  }

  auto_scaler_profile {
    balance_similar_node_groups      = true
    max_unready_nodes                = 1
    scale_down_utilization_threshold = "0.5"
    empty_bulk_delete_max            = "1"
    skip_nodes_with_system_pods      = false
  }

  identity {
    type = "SystemAssigned"
  }

  maintenance_window {
    allowed {
      day = "Tuesday"
      hours = [2, 3, 4, 5, 6, 7, 8]
    }
  }

  maintenance_window_auto_upgrade {
    duration    = 4
    frequency   = "Weekly"
    day_of_week = "Wednesday"
    start_time  = "02:00"
    interval    = 1
    utc_offset  = "+00:00"
  }

  network_profile {
    network_plugin      = "kubenet"
    load_balancer_sku   = "standard"
    ip_versions = ["IPv4", "IPv6"]
    load_balancer_profile {
      outbound_ip_address_ids = [azurerm_public_ip.nginx_ip_v4.id, azurerm_public_ip.nginx_ip_v6.id]
    }
  }

  oms_agent {
    log_analytics_workspace_id      = azurerm_log_analytics_workspace.analytics.id
    msi_auth_for_monitoring_enabled = true
  }

  monitor_metrics {}

  workload_autoscaler_profile {
    keda_enabled                    = true
    vertical_pod_autoscaler_enabled = false
  }
}
