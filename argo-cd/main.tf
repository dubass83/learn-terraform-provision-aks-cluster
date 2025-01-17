locals{
  password_file     = ".argocd-password.val"
  resources = split("\n---\n", data.http.install.body)
}


data "http" "install" {
  url = "https://raw.githubusercontent.com/argoproj/argo-cd/${var.argo_cd_version}/manifests/install.yaml"
}

# ----------------------------------------------------------------------------------------------------------------------
# Namespaces
# ----------------------------------------------------------------------------------------------------------------------
resource "kubernetes_namespace" "argo" {
  metadata {
    name = var.namespace
  }
  // depends_on = [null_resource.get-aks-credentials]
}

# ----------------------------------------------------------------------------------------------------------------------
# ArgoCD Resources
# ----------------------------------------------------------------------------------------------------------------------

resource "k8s_manifest" "resource" {
  count = length(local.resources)

  timeouts  {
    create = "5m"
    delete = "5m"
  }
  
  namespace = var.namespace
  content   = local.resources[count.index]

  depends_on = [kubernetes_namespace.argo]
}

resource "null_resource" "get_argocd_password" {
  depends_on = [k8s_manifest.resource]

  provisioner "local-exec" {
    command = "${path.module}/scripts/get-argocd-password.sh ${var.namespace} ${local.password_file}"

    environment = {
      KUBE_CTX = var.azurerm_kubernetes_cluster
    }
  }
}

data "local_file" "argocd_password" {
  depends_on = [null_resource.get_argocd_password]

  filename = local.password_file
}