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
variable "github_service_connection_id" {
  description = "Existing GitHub source endpoint UUID in the project; not the ARM OIDC endpoint."
  type        = string
}
