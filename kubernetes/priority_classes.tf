
resource "kubernetes_manifest" "high_priority" {
  manifest = yamldecode(
    file("kubernetes/manifests/prority_classes/high_priority.yaml")
  )
}

resource "kubernetes_manifest" "low_priority" {
  manifest = yamldecode(
    file("kubernetes/manifests/prority_classes/low_priority.yaml")
  )
}
