module "acr_pull" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-rbac.git?ref=47dda4c1f7b851941695ced6c5b48cc314ed3883"

  scope                = module.acr.acr_id
  principal_id         = module.identity.principal_id
  role_definition_name = "AcrPull"
}

module "pipeline_push" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-rbac.git?ref=47dda4c1f7b851941695ced6c5b48cc314ed3883"

  scope                = module.acr.acr_id
  principal_id         = module.devops.principal_id
  role_definition_name = "AcrPush"
}

module "pipeline_deploy" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-rbac.git?ref=47dda4c1f7b851941695ced6c5b48cc314ed3883"

  scope                = module.container_app.id
  principal_id         = module.devops.principal_id
  role_definition_name = "Contributor"
}

module "pipeline_read" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-rbac.git?ref=47dda4c1f7b851941695ced6c5b48cc314ed3883"

  scope                = azurerm_resource_group.foggykitchen_rg.id
  principal_id         = module.devops.principal_id
  role_definition_name = "Reader"
}
