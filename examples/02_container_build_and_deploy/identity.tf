module "identity" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-managed-identity.git?ref=0133e803177b5816e45c6a9cf64af0fb0af225ff"

  name                = "fk-pipeline-02-acr-pull"
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name
  location            = azurerm_resource_group.foggykitchen_rg.location
}
