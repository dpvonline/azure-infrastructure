resource "azurerm_virtual_network" "k8s-network" {
  name                = "k8s-network"
  location            = var.REGION
  resource_group_name = azurerm_resource_group.infra.name
  address_space = ["192.168.0.0/16", "2404:f800:8000:122::/63"]
  encryption {
    enforcement = "AllowUnencrypted"
  }
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  virtual_network_name = azurerm_virtual_network.k8s-network.name
  resource_group_name  = azurerm_resource_group.infra.name
  address_prefixes = ["192.168.0.0/22", "2404:f800:8000:122::/64"]
}

resource "azurerm_public_ip" "nginx_ip_v4" {
  name                 = "nginx-ingress-ip"
  location             = var.REGION
  resource_group_name  = azurerm_resource_group.infra.name
  allocation_method    = "Static"
  ddos_protection_mode = "Disabled"
  sku                  = "Standard"
}

resource "azurerm_public_ip" "nginx_ip_v6" {
  name                 = "nginx-ingress-ip-v6"
  location             = var.REGION
  ip_version           = "IPv6"
  resource_group_name  = azurerm_resource_group.infra.name
  allocation_method    = "Static"
  ddos_protection_mode = "Disabled"
  sku                  = "Standard"
}
