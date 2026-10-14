module "container_app" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-container-apps.git?ref=dca384858e67fc676ab1ace3a48d0658e09d8c9c"

  name                           = "fk-pipeline-02-app"
  environment_name               = "fk-pipeline-02-env"
  resource_group_name            = azurerm_resource_group.foggykitchen_rg.name
  location                       = azurerm_resource_group.foggykitchen_rg.location
  log_analytics_workspace_id     = module.log_analytics.id
  deployment_managed_by_pipeline = true
  # Consumption-only environments do not accept a workload profile name.
  workload_profile_name = null

  identity = {
    type         = "UserAssigned"
    identity_ids = [module.identity.id]
  }
  registries = [{
    server   = module.acr.acr_login_server
    identity = module.identity.id
  }]
  containers = [{
    name = "hello"
    # Bootstrap only; YAML deploys the tested application image from ACR.
    image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
    cpu    = 0.25
    memory = "0.5Gi"
  }]
  min_replicas = 0
  max_replicas = 1
  ingress = {
    external_enabled = true
    target_port      = 80
    transport        = "auto"
  }

  depends_on = [module.acr_pull]
}
