resource "kubernetes_namespace" "database" {
  metadata {
    name = "database"
    annotations = {
      "scheduler.alpha.kubernetes.io/defaultTolerations" = "[{\"Key\": \"kubernetes.azure.com/scalesetpriority\", \"Operator\": \"Equal\", \"Value\": \"spot\", \"Effect\": \"NoSchedule\"}]",
    }
  }
}

resource "kubernetes_secret" "postgres_secret" {
  metadata {
    name      = "postgres-secret"
    namespace = kubernetes_namespace.database.metadata[0].name
  }
  type = "Opaque"
  data = {
    POSTGRES_PASSWORD = var.DB_ROOT_PASSWORD
    POSTGRES_DB = "postgres"
    POSTGRES_USER = "postgres"

    PGADMIN_DEFAULT_EMAIL = var.DEFAULT_EMAIL
    PGADMIN_DEFAULT_PASSWORD = var.PGADMIN_PASSWORD
  }
}

resource "kubernetes_manifest" "storageclass" {
  manifest = yamldecode(
    file("kubernetes/manifests/db/storageclass.yml")
  )
}

resource "kubernetes_manifest" "postgres_pvc" {
  depends_on = [kubernetes_namespace.database]
  manifest = yamldecode(
    file("kubernetes/manifests/db/pvc.yml")
  )
}

resource "kubernetes_manifest" "postgres_deployment" {
  depends_on = [
    kubernetes_secret.postgres_secret,
    kubernetes_manifest.postgres_pvc,
  ]
  manifest = yamldecode(
    file("kubernetes/manifests/db/postgres-deployment.yml")
  )
}

resource "kubernetes_manifest" "database_service" {
  manifest = yamldecode(
    file("kubernetes/manifests/db/postgres-service.yml")
  )
}

resource "kubernetes_manifest" "pgadmin_config_map" {
  manifest = yamldecode(
    file("kubernetes/manifests/db/pgadmin-configmap.yml")
  )
}


resource "kubernetes_manifest" "pgadmin_deployment" {
  depends_on = [kubernetes_namespace.database, kubernetes_manifest.pgadmin_config_map]
  manifest = yamldecode(
    file("kubernetes/manifests/db/pgadmin-deployment.yml")
  )
}

resource "kubernetes_manifest" "pgadmin_service" {
  depends_on = [kubernetes_manifest.pgadmin_deployment]
  manifest = yamldecode(
    file("kubernetes/manifests/db/pgadmin-service.yml")
  )
}

resource "kubernetes_manifest" "database_ingress" {
  depends_on = [helm_release.ingress_config]
  manifest = yamldecode(
    templatefile("kubernetes/manifests/db/ingress.yml", {
      domain = var.DOMAIN,
    })
  )
}
