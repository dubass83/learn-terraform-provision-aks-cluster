locals {
  host              = "argocd.dubass83.xyz"
  name              = "argocd-cluster"
  url_endpoint      = "https://${local.host}"
}

resource "helm_release" "argocd-config" {
  depends_on = [null_resource.clean_up_instance, null_resource.delete_argocd_config_helm]

  name         = "argocd-config-system-apps"
  repository   = "https://charts.cloudnativetoolkit.dev"
  chart        = "argocd-config"
  version      = "v0.18.2" 
  namespace    = var.namespace
  force_update = true

  set {
    name  = "repoUrl"
    value = "https://github.com/dubass83/learn-terraform-provision-aks-cluster.git"
  }

  set {
    name  = "applicationTargets[0].createNamespace."
    value = true
  }

  set {
    name  = "applicationTargets[0].targetNamespace"
    value = "istio-system"
  }

  set {
    name  = "applicationTargets[0].applications[0].name"
    value = "istio"
  }

  // set {
  //   name  = "applicationTargets[0].applications[0].type"
  //   value = "helm"
  // }

    set {
    name  = "applicationTargets[0].applications[0].path"
    value = "istio-apps"
  }

    set {
    name  = "applicationTargets[1].createNamespace."
    value = true
  }

  set {
    name  = "applicationTargets[1].targetNamespace"
    value = "kube-system"
  }

  set {
    name  = "applicationTargets[1].applications[0].name"
    value = "system-apps"
  }

  // set {
  //   name  = "applicationTargets[1].applications[0].type"
  //   value = "helm"
  // }

    set {
    name  = "applicationTargets[1].applications[0].path"
    value = "system-apps"
  }

}