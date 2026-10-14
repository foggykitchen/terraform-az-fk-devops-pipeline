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
