resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = "keycloak"
    annotations = {
      "scheduler.alpha.kubernetes.io/defaultTolerations" = "[{\"Key\": \"kubernetes.azure.com/scalesetpriority\", \"Operator\": \"Equal\", \"Value\": \"spot\", \"Effect\": \"NoSchedule\"}]",
    }
  }
}

resource "kubernetes_secret" "keycloak_secret" {
  metadata {
    name      = "keycloak-secret"
    namespace = kubernetes_namespace.keycloak.metadata[0].name
  }
  type = "Opaque"
  data = {
    KC_HTTP_ENABLED    = "true"
    KC_PROXY_HEADERS   = "xforwarded"
    KC_DB              = "postgres"
    KC_DB_URL_HOST     = "postgres-service.database.svc.cluster.local"
    KC_DB_URL          = "jdbc:postgresql://postgres-service.database.svc.cluster.local:5432/keycloak"
    KC_DB_USERNAME     = "keycloak"
    KC_DB_PASSWORD     = var.DB_KEYCLOAK_PASSWORD
    KC_HOSTNAME        = "https://auth.${var.DOMAIN}"
    KC_HEALTH_ENABLED  = "true"
    KC_HOSTNAME_DEBUG  = "true"
  }
}

resource "kubernetes_manifest" "keycloak_pvc" {
  manifest = yamldecode(
    file("kubernetes/manifests/keycloak/pvc.yml")
  )
}

resource "kubernetes_manifest" "keycloak_deployment" {
  manifest = yamldecode(
    file("kubernetes/manifests/keycloak/deployment.yml")
  )
}

resource "kubernetes_manifest" "keycloak_service" {
  manifest = yamldecode(
    file("kubernetes/manifests/keycloak/service.yml")
  )
}

resource "kubernetes_manifest" "keycloak_ingress" {
  depends_on = [helm_release.ingress_config]
  manifest = yamldecode(
    templatefile("kubernetes/manifests/keycloak/ingress.yml", {
      domain = var.DOMAIN,
    })
  )
}
