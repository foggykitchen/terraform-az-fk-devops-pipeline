module "devops" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-devops.git?ref=25a5eca15641c81b23cad6d0a1d84330bc634dbf"

  project_name = "fk-pipeline-02"
  github_service_connections = {
    hello_world = { name = "fk-github-hello-world" }
  }

  service_connection = {
    name              = "fk-azure-oidc"
    subscription_id   = var.subscription_id
    subscription_name = var.subscription_name
  }

  variable_groups = {
    configuration = {
      name         = "fk-configuration"
      allow_access = false
      variables = {
        environment       = "dev"
        acrName           = module.acr.acr_name
        acrLoginServer    = module.acr.acr_login_server
        resourceGroupName = azurerm_resource_group.foggykitchen_rg.name
        containerAppName  = module.container_app.name
        applicationUrl    = "https://${module.container_app.fqdn}"
      }
    }
  }
}
