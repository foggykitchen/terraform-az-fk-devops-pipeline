module "acr" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-acr.git?ref=342bf5e6e8d47464501911bf0c3f263ebc95401b"

  acr_name            = "fkpipeline02${substr(sha256(azurerm_resource_group.foggykitchen_rg.id), 0, 10)}"
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name
  location            = azurerm_resource_group.foggykitchen_rg.location
  sku                 = "Basic"
  admin_enabled       = false
}
