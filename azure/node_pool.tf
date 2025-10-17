resource "azurerm_kubernetes_cluster_node_pool" "np1" {
  name                        = "np1spot"
  kubernetes_cluster_id       = azurerm_kubernetes_cluster.cluster.id
  vm_size                     = var.VM_SIZE
  eviction_policy             = "Delete"
  priority                    = "Spot"
  spot_max_price              = -1
  mode                        = "User"
  orchestrator_version        = "1.32.6"
  os_disk_type                = "Managed"
  os_sku                      = "AzureLinux"
  scale_down_mode             = "Delete"
  temporary_name_for_rotation = "spottmp1"
  ultra_ssd_enabled           = false
  vnet_subnet_id              = azurerm_subnet.internal.id
  auto_scaling_enabled        = true
  node_count                  = 1
  min_count                   = 1
  max_count                   = 2
  os_disk_size_gb             = 32
  zones = ["3",]
  node_public_ip_enabled      = false
  lifecycle {
    ignore_changes = [
      node_taints,
      node_count,
      orchestrator_version
    ]
  }
}


resource "azurerm_kubernetes_cluster_node_pool" "np2" {
  name                        = "np2spot"
  kubernetes_cluster_id       = azurerm_kubernetes_cluster.cluster.id
  vm_size                     = var.VM_SIZE_2
  eviction_policy             = "Delete"
  priority                    = "Spot"
  spot_max_price              = -1
  mode                        = "User"
  orchestrator_version        = "1.32.6"
  os_disk_type                = "Managed"
  os_sku                      = "AzureLinux"
  scale_down_mode             = "Delete"
  temporary_name_for_rotation = "spottmp2"
  ultra_ssd_enabled           = false
  vnet_subnet_id              = azurerm_subnet.internal.id
  auto_scaling_enabled        = true
  node_count                  = 1
  min_count                   = 1
  max_count                   = 2
  os_disk_size_gb             = 32
  zones = ["1",]
  node_public_ip_enabled      = true
  node_taints                 = ["only=special:NoSchedule"]
  lifecycle {
    ignore_changes = [
      node_taints,
      node_count,
      orchestrator_version
    ]
  }
}
