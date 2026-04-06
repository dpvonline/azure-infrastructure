
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

resource "kubernetes_manifest" "azureblob_nfs_storageclass" {
  manifest = yamldecode(
    file("kubernetes/manifests/storage_classes/azureblob-nfs.yml")
  )
}
