module "pipeline" {
  source = "../.."

  project_id            = module.devops.project_id
  pipeline_name         = "fk-pipeline-02"
  service_connection_id = module.devops.service_connection_id
  repository = {
    id                    = "foggykitchen/terraform-az-fk-devops-pipeline"
    branch_name           = "main"
    service_connection_id = module.devops.github_service_connection_ids["hello_world"]
  }
  yaml_path          = "examples/02_pipeline_with_variable_group_authorization/azure-pipelines.yml"
  variable_group_ids = module.devops.variable_group_ids
}
