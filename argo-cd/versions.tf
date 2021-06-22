terraform {
  required_providers {
    kubernetes = {
        source  = "hashicorp/kubernetes"
        version = ">= 1.13.0"
    }

    k8s = {
        source = "banzaicloud/k8s"
        version = ">= 0.8.0"
    }
  }

  required_version = "~> 0.14"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = var.azurerm_kubernetes_cluster
}

provider "k8s" {
  config_context = var.azurerm_kubernetes_cluster
}