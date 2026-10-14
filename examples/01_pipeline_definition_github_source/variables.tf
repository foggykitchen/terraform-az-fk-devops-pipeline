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
  description = "Existing Entra tenant ID."
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group created by this example."
  type        = string
  default     = "foggykitchen-rg"
}

variable "location" {
  description = "Azure region for the example Resource Group."
  type        = string
  default     = "westeurope"
}
