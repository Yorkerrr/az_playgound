output "primary_client_key" {
    value = azurerm_kubernetes_cluster.primary.kube_config.0.client_key
}

output "primary_client_certificate" {
    value = azurerm_kubernetes_cluster.primary.kube_config.0.client_certificate
}

output "primary_cluster_ca_certificate" {
    value = azurerm_kubernetes_cluster.primary.kube_config.0.cluster_ca_certificate
}

output "primary_cluster_username" {
    value = azurerm_kubernetes_cluster.primary.kube_config.0.username
}

output "primary_cluster_password" {
    value = azurerm_kubernetes_cluster.primary.kube_config.0.password
}

output "primary_kube_config" {
    value = azurerm_kubernetes_cluster.primary.kube_config_raw
}

output "primary_host" {
    value = azurerm_kubernetes_cluster.primary.kube_config.0.host
}

output "secondary_client_key" {
    value = azurerm_kubernetes_cluster.secondary.kube_config.0.client_key
}

output "secondary_client_certificate" {
    value = azurerm_kubernetes_cluster.secondary.kube_config.0.client_certificate
}

output "secondary_cluster_ca_certificate" {
    value = azurerm_kubernetes_cluster.secondary.kube_config.0.cluster_ca_certificate
}

output "secondary_cluster_username" {
    value = azurerm_kubernetes_cluster.secondary.kube_config.0.username
}

output "secondary_cluster_password" {
    value = azurerm_kubernetes_cluster.secondary.kube_config.0.password
}

output "secondary_kube_config" {
    value = azurerm_kubernetes_cluster.secondary.kube_config_raw
}

output "secondary_host" {
    value = azurerm_kubernetes_cluster.secondary.kube_config.0.host
}