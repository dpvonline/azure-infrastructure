resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
    annotations = {
      "scheduler.alpha.kubernetes.io/defaultTolerations" = "[{\"Key\": \"kubernetes.azure.com/scalesetpriority\", \"Operator\": \"Equal\", \"Value\": \"spot\", \"Effect\": \"NoSchedule\"}]",
      # "scheduler.alpha.kubernetes.io/defaultTolerations" = "[{\"Key\": \"CriticalAddonsOnly\", \"Operator\": \"Exists\"}]",
    }
  }
}

resource "helm_release" "ingress_config" {
  namespace  = kubernetes_namespace.ingress.metadata[0].name
  chart      = "ingress-nginx"
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  wait       = true
  version    = "4.12.4"

  values = [
    templatefile("kubernetes/manifests/ingress/controller-config.yml", {
      resource_group     = var.INFRA_NAME,
      loadbalancer_ip_v6 = var.PUBLIC_IP_V6,
      loadbalancer_ip    = var.PUBLIC_IP
    })
  ]
}

resource "kubernetes_manifest" "nginx_ingress" {
  depends_on = [helm_release.ingress_config]
  manifest = yamldecode(
    templatefile("kubernetes/manifests/ingress/ingress.yml", {
      domain = var.DOMAIN,
    })
  )
}
