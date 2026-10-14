module "pipeline" {
  source = "../.."

  project_id            = module.devops.project_id
  pipeline_name         = "fk-pipeline-02"
  service_connection_id = module.devops.service_connection_id
  repository = {
    id                    = "foggykitchen/foggykitchen-hello-world"
    branch_name           = "master"
    service_connection_id = module.devops.github_service_connection_ids["hello_world"]
  }
  yaml_path          = "azure-pipelines-cicd.yml"
  variable_group_ids = module.devops.variable_group_ids

  depends_on = [module.pipeline_push, module.pipeline_deploy, module.pipeline_read]
}
