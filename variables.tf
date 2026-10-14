variable "project_id" {
  description = "Existing Azure DevOps project ID from terraform-az-fk-devops."
  type        = string
  nullable    = false
  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.project_id))
    error_message = "project_id must be a UUID."
  }
}

variable "pipeline_name" {
  description = "Name of the YAML pipeline definition."
  type        = string
  nullable    = false
  validation {
    condition     = length(trimspace(var.pipeline_name)) > 0
    error_message = "pipeline_name must not be blank."
  }
}

variable "repository" {
  description = "Existing source repository: GitHub owner/repository plus source endpoint, or TfsGit repository UUID."
  type = object({
    type                  = optional(string, "GitHub")
    id                    = string
    branch_name           = optional(string, "main")
    service_connection_id = optional(string)
  })
  nullable = false
  validation {
    condition     = contains(["GitHub", "TfsGit"], var.repository.type) && length(trimspace(var.repository.branch_name)) > 0
    error_message = "repository.type must be GitHub or TfsGit and branch_name must not be blank."
  }
  validation {
    condition = var.repository.type == "GitHub" ? (
      can(regex("^[^/[:space:]]+/[^/[:space:]]+$", var.repository.id)) &&
      can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.repository.service_connection_id))
      ) : (
      can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.repository.id)) && var.repository.service_connection_id == null
    )
    error_message = "GitHub requires owner/repository and a source endpoint UUID; TfsGit requires a repository UUID and no source endpoint."
  }
}

variable "yaml_path" {
  description = "Repository-relative path to an existing YAML pipeline file; content is caller-owned."
  type        = string
  nullable    = false
  validation {
    condition     = length(trimspace(var.yaml_path)) > 0 && !startswith(var.yaml_path, "/") && !can(regex("(^|/)[.][.](/|$)", var.yaml_path))
    error_message = "yaml_path must be a nonblank repository-relative path without parent traversal."
  }
}

variable "service_connection_id" {
  description = "Existing ARM OIDC service connection ID from terraform-az-fk-devops to authorize for this pipeline."
  type        = string
  nullable    = false
  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.service_connection_id))
    error_message = "service_connection_id must be an ARM service connection UUID."
  }
}

variable "variable_group_ids" {
  description = "Existing variable group IDs keyed by stable logical name; attached and authorized for this pipeline."
  type        = map(number)
  default     = {}
  nullable    = false
  validation {
    condition     = alltrue([for key, id in var.variable_group_ids : length(trimspace(key)) > 0 && id >= 1 && floor(id) == id])
    error_message = "Variable group keys must not be blank and IDs must be positive integers."
  }
  validation {
    condition     = length(distinct(values(var.variable_group_ids))) == length(var.variable_group_ids)
    error_message = "Variable group IDs must be unique."
  }
}

variable "ci_trigger_use_yaml" {
  description = "Delegate CI to YAML when true; false removes definition CI without adding trigger logic."
  type        = bool
  default     = true
  nullable    = false
}
