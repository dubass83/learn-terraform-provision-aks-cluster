locals{
  tmp_dir           = "${path.cwd}/.tmp"
  password_file     = "${local.tmp_dir}/argocd-password.val"
}

// Get cluster credentials so we can perform tasks on it
resource "null_resource" "get-aks-credentials" {
  provisioner "local-exec" {
    command = "az aks get-credentials --resource-group ${var.azurerm_resource_group} --name ${var.azurerm_kubernetes_cluster}"
  }
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
}

# ----------------------------------------------------------------------------------------------------------------------
# ArgoCD Resources
# ----------------------------------------------------------------------------------------------------------------------
locals {
  resources = split("\n---\n", data.http.install.body)
}

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

    // environment = {
    //   KUBECONFIG = var.cluster_config_file
    // }
  }
}

data "local_file" "argocd_password" {
  depends_on = [null_resource.get_argocd_password]

  filename = local.password_file
}