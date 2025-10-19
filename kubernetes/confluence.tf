resource "kubernetes_namespace" "confluence" {
  metadata {
    name = "wiki"
    annotations = {
      "scheduler.alpha.kubernetes.io/defaultTolerations" = "[{\"Key\": \"kubernetes.azure.com/scalesetpriority\", \"Operator\": \"Equal\", \"Value\": \"spot\", \"Effect\": \"NoSchedule\"}]",
    }
  }
}

resource "kubernetes_secret" "confluence_db" {
  depends_on = [kubernetes_namespace.confluence]
  metadata {
    name      = "confluence-secret"
    namespace = kubernetes_namespace.confluence.metadata[0].name
  }
  type = "Opaque"
  data = {
    ATL_JDBC_URL         = format("jdbc:postgresql://postgres-service.database.svc.cluster.local:5432/%s", var.DB_CONFLUENCE_NAME)
    ATL_JDBC_USER        = var.DB_CONFLUENCE_USER
    ATL_JDBC_PASSWORD    = var.DB_CONFLUENCE_PASSWORD
    ATL_DB_TYPE          = "postgresql"
    ATL_PROXY_NAME       = format("wiki.%s", var.PROD_DOMAIN)
    JVM_MINIMUM_MEMORY   = "1024m"
    JVM_MAXIMUM_MEMORY   = "3072m"
    ATL_TOMCAT_SCHEME    = "https"
    ATL_TOMCAT_SECURE    = "true"
    ATL_FORCE_CFG_UPDATE = "false"
    ATL_LICENSE_KEY      = var.CONFLUENCE_LICENSE
  }
}

resource "kubernetes_manifest" "confluence_pvc" {
  depends_on = [kubernetes_namespace.confluence, kubernetes_manifest.premium_storageclass]
  manifest = yamldecode(
    file("kubernetes/manifests/confluence/pvc.yml")
  )
}

resource "kubernetes_manifest" "confluence_deployment" {
  depends_on = [kubernetes_namespace.confluence, kubernetes_manifest.confluence_deployment]
  manifest = yamldecode(
    file("kubernetes/manifests/confluence/deployment.yml")
  )
}

resource "kubernetes_manifest" "confluence_service" {
  depends_on = [kubernetes_namespace.confluence]
  manifest = yamldecode(
    file("kubernetes/manifests/confluence/service.yml")
  )
}

resource "kubernetes_manifest" "confluence_ingress" {
  depends_on = [kubernetes_namespace.confluence]
  manifest = yamldecode(
    templatefile("kubernetes/manifests/confluence/ingress.yml", {
      domain = var.PROD_DOMAIN
    })
  )
}
