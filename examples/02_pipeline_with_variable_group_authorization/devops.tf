module "devops" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-devops.git?ref=cf5a49b17958108aa874ef8010800f48bb4b10f6"

  project_name = "fk-pipeline-02"
  service_connection = {
    name              = "fk-azure-oidc"
    subscription_id   = var.subscription_id
    subscription_name = var.subscription_name
  }

  variable_groups = {
    configuration = {
      name         = "fk-configuration"
      allow_access = false
      variables    = { environment = "dev" }
    }
  }
}
