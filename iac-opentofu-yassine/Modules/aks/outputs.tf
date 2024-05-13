output "kubelet_identity_object_id" {
  value       = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity.0.object_id
  description = "Specifies the object id of the kubelet identity of the AKS cluster."
}

output "kube_config_raw" {
  value       = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  description = "Contains the Kubernetes config to be used by kubectl and other compatible tools."
}
output "name" {
  value       = azurerm_kubernetes_cluster.aks_cluster.name
  description = "Specifies the name of the AKS cluster."
}

output "id" {
  value       = azurerm_kubernetes_cluster.aks_cluster.id
  description = "Specifies the resource id of the AKS cluster."
}
