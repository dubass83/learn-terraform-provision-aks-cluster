variable "appId" {
  type = string
  description = "Azure Kubernetes Service Cluster service principal"
}

variable "password" {
  type = string
  description = "Azure Kubernetes Service Cluster password"
}

variable "location" {
  description = "Azure Location"
  type = string
}

variable "env" {
  type = string
  description = "App enviroment"
}

variable "node_count" {
  type = number
}

variable "vm_size" {
  type = string
}

variable "os_disk_size_gb" {
  type = number
}