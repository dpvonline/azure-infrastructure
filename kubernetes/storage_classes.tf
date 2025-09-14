
resource "kubernetes_manifest" "standard_storageclass" {
  manifest = yamldecode(
    file("kubernetes/manifests/storage_classes/standard.yml")
  )
}

resource "kubernetes_manifest" "premium_storageclass" {
  manifest = yamldecode(
    file("kubernetes/manifests/storage_classes/premium.yml")
  )
}
