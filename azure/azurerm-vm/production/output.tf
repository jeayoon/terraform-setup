output "azurerm_resource_group" {
  value = module.resource_group.name
}
output "tls_private_key" {
  value = module.virtual_machine.tls_private_key
}

# output "client_key" {
#   value = module.k8s.client_key
# }
# output "client_certificate" {
#   value = module.k8s.client_certificate
# }
# output "cluster_ca_certificate" {
#   value = module.k8s.cluster_ca_certificate
# }
# output "cluster_username" {
#   value = module.k8s.cluster_username
# }
# output "cluster_password" {
#   value = module.k8s.cluster_password
# }
# output "kube_config" {
#   value = module.k8s.kube_config
# }
# output "host" {
#   value = module.k8s.host
# }