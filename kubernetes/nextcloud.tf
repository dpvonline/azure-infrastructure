resource "kubernetes_namespace" "nextcloud" {
  metadata {
    name = "nextcloud"
    annotations = {
      "scheduler.alpha.kubernetes.io/defaultTolerations" = "[{\"Key\": \"kubernetes.azure.com/scalesetpriority\", \"Operator\": \"Equal\", \"Value\": \"spot\", \"Effect\": \"NoSchedule\"}]",
    }
  }
}

resource "kubernetes_secret" "nextcloud_secret" {
  metadata {
    name      = "nextcloud-secret"
    namespace = kubernetes_namespace.nextcloud.metadata[0].name
  }
  type = "Opaque"
  data = {
    DB_HOST        = "postgres-service.database.svc.cluster.local"
    DB_NAME        = var.DB_NEXTCLOUD_NAME
    DB_USER        = var.DB_NEXTCLOUD_USER
    DB_PASSWORD    = var.DB_NEXTCLOUD_PW
    NEXTCLOUD_USER = var.NEXTCLOUD_USER
    NEXTCLOUD_PW   = var.NEXTCLOUD_PW
    COLLABORA_USER = var.COLLABORA_USER
    COLLABORA_PW   = var.COLLABORA_PW
  }
}

resource "kubernetes_manifest" "nextcloud_storageclass" {
  manifest = yamldecode(
    file("kubernetes/manifests/nextcloud/storageclass.yml")
  )
}

resource "kubernetes_manifest" "pvc_nextcloud" {
  depends_on = [kubernetes_namespace.database]
  manifest = yamldecode(
    file("kubernetes/manifests/nextcloud/pvc.yml")
  )
}


resource "helm_release" "nextcloud" {
  depends_on = [kubernetes_namespace.nextcloud, kubernetes_secret.nextcloud_secret, kubernetes_manifest.pvc_nextcloud]
  namespace  = kubernetes_namespace.nextcloud.metadata[0].name
  chart      = "nextcloud"
  name       = "nextcloud"
  repository = "https://nextcloud.github.io/helm/"
  wait       = true

  values = [
    templatefile("kubernetes/manifests/nextcloud/nextcloud-config.yml", {
      cloud_domain     = "cloud.${var.DOMAIN}"
      collabora_domain = "office.${var.DOMAIN}"
    })
  ]
}

resource "kubernetes_manifest" "nextcloud_ingress" {
  depends_on = [helm_release.ingress_config]
  manifest = yamldecode(
    templatefile("kubernetes/manifests/nextcloud/ingress.yml", {
      domain = var.DOMAIN,
    })
  )
}
