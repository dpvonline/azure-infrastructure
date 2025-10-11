resource "kubernetes_namespace" "redis" {
  metadata {
    name = "redis"
    annotations = {
      "scheduler.alpha.kubernetes.io/defaultTolerations" = "[{\"Key\": \"CriticalAddonsOnly\", \"Operator\": \"Exists\"}, {\"Key\": \"only\", \"Operator\":\"Equal\", \"Value\":\"special\", \"Effect\":\"NoSchedule\"},{\"Key\": \"kubernetes.azure.com/scalesetpriority\", \"Operator\": \"Equal\", \"Value\": \"spot\", \"Effect\": \"NoSchedule\"}]",
      # "scheduler.alpha.kubernetes.io/node-selector"      = "agentpool=system"
    }
  }
}

resource "kubernetes_secret" "redis_secret" {
  metadata {
    name      = "redis-secret"
    namespace = kubernetes_namespace.redis.metadata[0].name
  }
  type = "Opaque"
  data = {
    REDIS_PASSWORD             = var.REDIS_PASSWORD
    REDIS_ALLOW_EMPTY_PASSWORD = "no"
  }
}

resource "kubernetes_manifest" "redis_pvc" {
  depends_on = [helm_release.ingress_config]
  manifest = yamldecode(
    file("kubernetes/manifests/redis/pvc.yml")
  )
}

resource "kubernetes_manifest" "redis_deployment" {
  depends_on = [helm_release.ingress_config, kubernetes_manifest.redis_pvc]
  manifest = yamldecode(
    file("kubernetes/manifests/redis/deployment.yaml")
  )
}

resource "kubernetes_manifest" "redis_service" {
  depends_on = [helm_release.ingress_config]
  manifest = yamldecode(
    file("kubernetes/manifests/redis/service.yaml")
  )
}
