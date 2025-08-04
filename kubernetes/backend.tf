resource "kubernetes_namespace" "biber" {
  metadata {
    name = "biber"
    annotations = {
      "scheduler.alpha.kubernetes.io/defaultTolerations" = "[{\"Key\": \"kubernetes.azure.com/scalesetpriority\", \"Operator\": \"Equal\", \"Value\": \"spot\", \"Effect\": \"NoSchedule\"}]",
    }
  }
}

resource "kubernetes_secret" "biber_secret" {
  metadata {
    name      = "biber-secret"
    namespace = kubernetes_namespace.biber.metadata[0].name
  }
  type = "Opaque"
  data = {
    DEBUG               = "True"
    SECRET_KEY          = var.DJANGO_SECRET_KEY
    EMAIL_BACKEND       = "django.core.mail.backends.console.EmailBackend"
    EMAIL_HOST          = var.EMAIL_HOST
    EMAIL_HOST_USER     = var.EMAIL_HOST_USER
    EMAIL_HOST_PASSWORD = var.EMAIL_HOST_PASSWORD
    EMAIL_PORT          = var.EMAIL_PORT
    EMAIL_USE_TLS       = var.EMAIL_USE_TLS
    EMAIL_USE_SSL       = var.EMAIL_USE_SSL
    DEFAULT_FROM_EMAIL  = var.EMAIL_HOST_USER
    DB_NAME             = var.DB_BIBER_NAME
    DB_USERNAME         = var.DB_BIBER_USER
    DB_PASSWORD         = var.DB_BIBER_PASSWORD
    DB_PORT             = "5432"
    DB_HOSTNAME         = "postgres-service.database.svc.cluster.local"
  }
}

resource "kubernetes_manifest" "backend-service" {
  manifest = yamldecode(
    file("kubernetes/manifests/backend/service.yml")
  )
}

resource "kubernetes_manifest" "nginx-config" {
  manifest = yamldecode(
    file("kubernetes/manifests/backend/nginx-config.yml")
  )
}

resource "kubernetes_manifest" "backend-pvc" {
  manifest = yamldecode(
    file("kubernetes/manifests/backend/pvc.yml")
  )
}

resource "kubernetes_manifest" "backend-deployment" {
  manifest = yamldecode(
    file("kubernetes/manifests/backend/deployment.yml")
  )
}

resource "kubernetes_manifest" "backend-ingress" {
  manifest = yamldecode(
    templatefile("kubernetes/manifests/backend/ingress.yml", {
      domain = var.DOMAIN,
    })
  )
}
