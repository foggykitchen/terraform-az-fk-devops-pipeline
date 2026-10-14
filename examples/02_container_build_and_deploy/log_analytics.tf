module "log_analytics" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-log-analytics.git?ref=44c5b0eb0839aed6e707664076422d8398dfa2d6"

  name                = "fk-pipeline-02-logs"
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name
  location            = azurerm_resource_group.foggykitchen_rg.location
  retention_in_days   = 30
  daily_quota_gb      = 0.1
}
