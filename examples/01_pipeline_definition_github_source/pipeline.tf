module "pipeline" {
  source = "../.."

  project_id            = module.devops.project_id
  pipeline_name         = "fk-pipeline-01"
  service_connection_id = module.devops.service_connection_id
  repository = {
    id                    = "foggykitchen/foggykitchen-hello-world"
    branch_name           = "master"
    service_connection_id = module.devops.github_service_connection_ids["hello_world"]
  }
  yaml_path = "azure-pipelines.yml"
}
