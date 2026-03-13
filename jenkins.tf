resource "kubernetes_namespace_v1" "jenkins" {
  metadata {
    name = "jenkins"
  }
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  namespace  = kubernetes_namespace_v1.jenkins.metadata[0].name
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "5.8.6"

  timeout = 1200
  wait    = true

  set = [
    # без PVC (щоб не чіпати EBS CSI)
    { name = "persistence.enabled", value = "false" },

    # ✅ Встановлюємо базові потрібні плагіни для Pipeline + Git + Credentials
    { name = "controller.installPlugins[0]", value = "workflow-aggregator" },
    { name = "controller.installPlugins[1]", value = "git" },
    { name = "controller.installPlugins[2]", value = "credentials" },
    { name = "controller.installPlugins[3]", value = "credentials-binding" },
    { name = "controller.installPlugins[4]", value = "kubernetes" },

    # ✅ Дозволяємо ставити “latest” для них
    { name = "controller.installLatestPlugins", value = "true" },
    { name = "controller.installLatestSpecifiedPlugins", value = "true" },

    # ресурси
    { name = "controller.resources.requests.cpu", value = "100m" },
    { name = "controller.resources.requests.memory", value = "256Mi" },
    { name = "controller.resources.limits.cpu", value = "500m" },
    { name = "controller.resources.limits.memory", value = "1Gi" },

    { name = "controller.serviceType", value = "ClusterIP" }
  ]
}
