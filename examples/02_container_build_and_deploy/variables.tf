variable "organization_url" {
  description = "Existing Azure DevOps organization URL."
  type        = string
}
variable "subscription_id" {
  description = "Existing Azure subscription UUID for the upstream ARM connection."
  type        = string
}
variable "subscription_name" {
  description = "Existing Azure subscription display name."
  type        = string
}

variable "tenant_id" {
  description = "Existing Entra tenant UUID for bootstrap authentication."
  type        = string
}

variable "resource_group_name" {
  description = "Dedicated resource group created for the CI/CD example."
  type        = string
  default     = "foggykitchen-pipeline-02-rg"
}

variable "location" {
  description = "Azure region for the application infrastructure."
  type        = string
  default     = "westeurope"
}
