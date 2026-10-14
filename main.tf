resource "azuredevops_build_definition" "this" {
  project_id      = var.project_id
  name            = var.pipeline_name
  variable_groups = length(var.variable_group_ids) == 0 ? null : values(var.variable_group_ids)

  repository {
    repo_type             = var.repository.type
    repo_id               = var.repository.id
    branch_name           = var.repository.branch_name
    yml_path              = var.yaml_path
    service_connection_id = var.repository.service_connection_id
  }

  dynamic "ci_trigger" {
    for_each = var.ci_trigger_use_yaml ? [true] : []
    content {
      use_yaml = true
    }
  }

  features {
    skip_first_run = true
  }
}

locals {
  source_endpoints = var.repository.type == "GitHub" ? { github = var.repository.service_connection_id } : {}
  endpoints        = merge({ arm = var.service_connection_id }, local.source_endpoints)
}

resource "azuredevops_pipeline_authorization" "endpoint" {
  for_each = local.endpoints

  project_id  = var.project_id
  resource_id = each.value
  type        = "endpoint"
  pipeline_id = azuredevops_build_definition.this.id
}

resource "azuredevops_pipeline_authorization" "variable_group" {
  for_each = var.variable_group_ids

  project_id  = var.project_id
  resource_id = tostring(each.value)
  type        = "variablegroup"
  pipeline_id = azuredevops_build_definition.this.id
}
