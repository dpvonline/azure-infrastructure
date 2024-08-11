resource "kubernetes_namespace" "kube_system" {
  metadata {
    name = "kube-system"
    annotations = {
      "scheduler.alpha.kubernetes.io/defaultTolerations" = "[{\"Key\": \"kubernetes.azure.com/scalesetpriority\", \"Operator\": \"Equal\", \"Value\": \"spot\", \"Effect\": \"NoSchedule\"},{\"Key\": \"CriticalAddonsOnly\", \"Operator\": \"Exists\"}]",
    }
    labels = {
      "control-plane"                  = true,
      "kubernetes.azure.com/managedby" = "aks",
    }
  }
}
