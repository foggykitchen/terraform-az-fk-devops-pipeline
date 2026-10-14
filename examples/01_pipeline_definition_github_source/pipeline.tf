module "pipeline" {
  source = "../.."

  project_id            = module.devops.project_id
  pipeline_name         = "fk-pipeline-01"
  service_connection_id = module.devops.service_connection_id
  repository = {
    id                    = "foggykitchen/terraform-az-fk-devops-pipeline"
    branch_name           = "main"
    service_connection_id = var.github_service_connection_id
  }
  yaml_path = "examples/01_pipeline_definition_github_source/azure-pipelines.yml"
}
