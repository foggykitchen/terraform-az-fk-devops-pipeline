output "pipeline_id" {
  description = "YAML pipeline definition ID, ready after endpoint and variable-group permissions are registered."
  value       = azuredevops_build_definition.this.id
  depends_on  = [azuredevops_pipeline_authorization.endpoint, azuredevops_pipeline_authorization.variable_group]
}

output "pipeline_name" {
  description = "YAML pipeline definition name."
  value       = azuredevops_build_definition.this.name
}

output "project_id" {
  description = "Azure DevOps project ID used by the pipeline."
  value       = var.project_id
}
