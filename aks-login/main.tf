// Get cluster credentials so we can perform tasks on it
resource "null_resource" "get-aks-credentials" {
  provisioner "local-exec" {
    command = "az aks get-credentials --resource-group ${var.azurerm_resource_group} --name ${var.azurerm_kubernetes_cluster}"
  }
}