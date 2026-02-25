resource "kubernetes_namespace_v1" "jenkins" {
  metadata { name = "jenkins" }
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
    # без PVC (щоб не чіпати EBS CSI взагалі)
    { name = "persistence.enabled", value = "false" },

    # ⚠️ КЛЮЧОВЕ: не встановлюємо плагіни через init / plugins.txt
    { name = "controller.installPlugins", value = "" },
    { name = "controller.installLatestPlugins", value = "false" },
    { name = "controller.installLatestSpecifiedPlugins", value = "false" },

    # трохи легші ресурси
    { name = "controller.resources.requests.cpu", value = "100m" },
    { name = "controller.resources.requests.memory", value = "256Mi" },
    { name = "controller.resources.limits.cpu", value = "500m" },
    { name = "controller.resources.limits.memory", value = "1Gi" },

    { name = "controller.serviceType", value = "ClusterIP" }
  ]
}
