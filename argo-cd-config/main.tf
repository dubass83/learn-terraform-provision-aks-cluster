locals{
  // apps_istio = "k8s-manifests/apps-istio.yaml"
  // resources_istio = split("\n---\n", data.local_file.argocd_apps_istio.content)
  apps_system = "k8s-manifests/apps-system.yaml"
  resources_system = split("\n---\n", data.local_file.argocd_apps_system.content)
}


// data "local_file" "argocd_apps_istio" {
//   filename = local.apps_istio
// }

data "local_file" "argocd_apps_system" {
  filename = local.apps_system
}

# ----------------------------------------------------------------------------------------------------------------------
# Namespaces
# ----------------------------------------------------------------------------------------------------------------------
// resource "kubernetes_namespace" "istio" {
//   metadata {
//     name = var.istio_namespace
//   }
// }

# ----------------------------------------------------------------------------------------------------------------------
# ArgoCD Resources
# ----------------------------------------------------------------------------------------------------------------------

resource "k8s_manifest" "resources_system" {
  count = length(local.resources_system)

  timeouts  {
    create = "5m"
    delete = "5m"
  }
  
  namespace = "kube-system"
  content   = local.resources_system[count.index]

}

// resource "k8s_manifest" "resources_istio" {
//   count = length(local.resources_istio)

//   timeouts  {
//     create = "5m"
//     delete = "5m"
//   }
  
//   namespace = var.istio_namespace
//   content   = local.resources_istio[count.index]

//   depends_on = [kubernetes_namespace.istio, k8s_manifest.resources_system]
// }