resource "kubernetes_manifest" "backend-service" {
  manifest = yamldecode(
    file("kubernetes/manifests/backend/service.yml")
  )
}

resource "kubernetes_manifest" "backend-config" {
  manifest = yamldecode(
    file("kubernetes/manifests/backend/config-map.yml")
  )
}

resource "kubernetes_manifest" "backend-deployment" {
  manifest = yamldecode(
    file("kubernetes/manifests/backend/deployment.yml")
  )
}
