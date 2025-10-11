resource "kubernetes_namespace" "nextcloud" {
  metadata {
    name = "nextcloud"
    annotations = {
      "scheduler.alpha.kubernetes.io/defaultTolerations" = "[{\"Key\": \"only\", \"Operator\":\"Equal\", \"Value\":\"special\", \"Effect\":\"NoSchedule\"},{\"Key\": \"kubernetes.azure.com/scalesetpriority\", \"Operator\": \"Equal\", \"Value\": \"spot\", \"Effect\": \"NoSchedule\"}]"
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
    DB_HOST             = "postgres-service.database.svc.cluster.local:5432"
    DB_NAME             = var.DB_NEXTCLOUD_NAME
    DB_USER             = var.DB_NEXTCLOUD_USER
    DB_PASSWORD         = var.DB_NEXTCLOUD_PW
    NEXTCLOUD_USER      = var.NEXTCLOUD_USER
    NEXTCLOUD_PW        = var.NEXTCLOUD_PW
    EMAIL_HOST          = var.EMAIL_HOST
    COLLABORA_USER      = var.COLLABORA_USER
    COLLABORA_PW        = var.COLLABORA_PW
    EMAIL_HOST_USER     = var.EMAIL_HOST_USER
    EMAIL_HOST_PASSWORD = var.EMAIL_HOST_PASSWORD
    EMAIL_PORT          = var.EMAIL_PORT
    EMAIL_USE_TLS       = var.EMAIL_USE_TLS
    EMAIL_USE_SSL       = var.EMAIL_USE_SSL
    DEFAULT_FROM_EMAIL  = var.EMAIL_HOST_USER
  }
}

resource "kubernetes_manifest" "pvc_nextcloud" {
  depends_on = [kubernetes_manifest.standard_storageclass]
  manifest = yamldecode(
    file("kubernetes/manifests/nextcloud/pvc.yml")
  )
}

resource "helm_release" "nextcloud" {
  depends_on = [kubernetes_namespace.nextcloud, kubernetes_secret.nextcloud_secret, kubernetes_manifest.pvc_nextcloud]
  namespace  = kubernetes_namespace.nextcloud.metadata[0].name
  chart      = "nextcloud"
  name       = "nextcloud"
  version    = "7.0.4"
  repository = "https://nextcloud.github.io/helm/"
  wait       = true
  timeout    = 900

  values = [
    templatefile("kubernetes/manifests/nextcloud/nextcloud-config.yml", {
      cloud_domain     = "cloud.${var.PROD_DOMAIN}"
      collabora_domain = "office.${var.PROD_DOMAIN}"
      # SMTP-related values templated from Terraform vars
      email_host     = var.EMAIL_HOST
      email_user     = var.EMAIL_HOST_USER
      email_password = var.EMAIL_HOST_PASSWORD
      email_port     = var.EMAIL_PORT
      # split address into local-part + domain for Nextcloud config
      email_from_localpart = split("@", var.EMAIL_HOST_USER)[0]
      email_domain         = split("@", var.EMAIL_HOST_USER)[1]
      redis_host           = "redis-service.redis.svc.cluster.local"
      redis_port           = "6379"
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
