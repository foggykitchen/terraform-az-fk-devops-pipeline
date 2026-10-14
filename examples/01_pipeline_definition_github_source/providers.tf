terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "= 3.10.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "= 1.16.0"
    }
  }
}

provider "azuredevops" {
  org_service_url = var.organization_url
}

provider "azuread" {}
