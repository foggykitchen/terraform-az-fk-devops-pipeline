output "pipeline_id" {
  description = "Registered YAML pipeline ID after permissions."
  value       = module.pipeline.pipeline_id
}
output "project_id" {
  description = "Upstream Azure DevOps project ID."
  value       = module.devops.project_id
}
output "service_connection_id" {
  description = "Upstream ARM OIDC connection ID."
  value       = module.devops.service_connection_id
}

output "github_service_connection_id" {
  description = "GitHub source connection ID created by the upstream module."
  value       = module.devops.github_service_connection_ids["hello_world"]
}

output "application_url" {
  description = "Public HTTPS endpoint; the bootstrap application is replaced by the pipeline deployment."
  value       = "https://${module.container_app.fqdn}"
}

output "acr_login_server" {
  description = "Registry receiving the tested application image."
  value       = module.acr.acr_login_server
}

output "resource_group_id" {
  description = "Dedicated application resource group ID."
  value       = azurerm_resource_group.foggykitchen_rg.id
}
