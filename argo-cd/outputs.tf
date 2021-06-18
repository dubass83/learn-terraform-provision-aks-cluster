  output "argocd_password" {
    value = data.local_file.argocd_password.content
  }