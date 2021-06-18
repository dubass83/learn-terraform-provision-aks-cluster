variable "azurerm_resource_group" {
  type = string
}

variable "azurerm_kubernetes_cluster" {
    type = string
}

variable "argo_cd_version" {
    type    = string
    default = "stable"
}

variable "namespace" {
    type    = string
    default = "argocd" 
}