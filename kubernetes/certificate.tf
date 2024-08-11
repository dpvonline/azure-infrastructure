resource "kubernetes_namespace" "cert-manager-ns" {
  metadata {
    name = "cert-manager"
    annotations = {
      "scheduler.alpha.kubernetes.io/defaultTolerations" = "[{\"Key\": \"kubernetes.azure.com/scalesetpriority\", \"Operator\": \"Equal\", \"Value\": \"spot\", \"Effect\": \"NoSchedule\"}]",
      # "scheduler.alpha.kubernetes.io/defaultTolerations" = "[{\"Key\": \"CriticalAddonsOnly\", \"Operator\": \"Exists\"}]",
    }
  }
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = kubernetes_namespace.cert-manager-ns.metadata[0].name
  version    = "1.18.2"
  depends_on = [helm_release.ingress_config]

  values = [
    file("kubernetes/manifests/certificate/cert-manager-config.yml")
  ]
}

resource "kubernetes_manifest" "cert-manager-configuration" {
  depends_on = [helm_release.cert-manager]
  manifest   = yamldecode(
    templatefile("kubernetes/manifests/certificate/cert-nginx.yml", { email = var.DEFAULT_EMAIL })
  )
}
