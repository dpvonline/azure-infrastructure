output "k8s_konfig" {
  value = azurerm_kubernetes_cluster.cluster.kube_config[0]
}

output "public_ip" {
  value = azurerm_public_ip.nginx_ip_v4.ip_address
}

output "public_ip_v6" {
  value = azurerm_public_ip.nginx_ip_v6.ip_address
}

resource "local_file" "kubeconfig" {
    content  = yamlencode(azurerm_kubernetes_cluster.cluster.kube_config_raw)
    filename = "kubeconfig.yaml"
}
