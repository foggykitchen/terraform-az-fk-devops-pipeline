# Azure Pipelines with Terraform/OpenTofu – Training Examples

This directory contains all progressive examples used with the **terraform-az-fk-devops-pipeline** module.
The examples are designed as **incremental building blocks**, starting with a GitHub-sourced YAML pipeline definition and then introducing variable-group attachment and per-pipeline authorization.

These examples are part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses)** and focus on Azure Pipelines control-plane configuration.

**Pipeline delivery logic remains in caller-owned YAML.** Each example includes only a trivial placeholder file; neither implements an OpenTofu plan/apply workflow.

---

## 🧭 Example Overview

| Example | Title | Key Topics |
|:-------:|:------|:-----------|
| [01](01_pipeline_definition_github_source/) | **Pipeline Definition with GitHub Source** | Upstream project/WIF composition, existing GitHub connection, YAML path, individual endpoint permissions |
| [02](02_pipeline_with_variable_group_authorization/) | **Pipeline with Variable Group Authorization** | Same foundation, upstream nonsecret configuration group, definition attachment, individual group permissions |

Each example builds on the **concepts** introduced in the previous one, but uses its own configuration and state. The examples use different project names: `fk-pipeline-01` and `fk-pipeline-02`.

---

## ⚙️ How to Use

Each example directory contains:

- Terraform/OpenTofu configuration in responsibility-named `.tf` files
- A focused `README.md` with architecture, deployment, verification and cleanup guidance
- A safe `terraform.tfvars.example` containing only nonsecret placeholders
- Explicit provider version and upstream module commit pins
- An architecture diagram and an Azure DevOps portal evidence section
- A minimal `azure-pipelines.yml` placeholder referenced by the definition

Start with static checks:

```bash
cd examples/01_pipeline_definition_github_source
cp terraform.tfvars.example terraform.tfvars
# Replace the nonsecret placeholder identifiers before deployment.
tofu init -backend=false
tofu fmt -check
tofu validate
```

The recommended learning sequence is:
**01 → 02**

Read the selected example's Deployment Steps before provisioning it. Both require an existing Azure DevOps organization and subscription, bootstrap authentication and administration rights. A fresh project requires staged setup: create the upstream resources, register a GitHub source connection in that project, then register the pipeline. The ARM OIDC connection does not authenticate GitHub.

Both examples passed static validation with OpenTofu **1.11.6** on **October 14, 2026**. No plan, apply or pipeline execution was performed.

---

## 🧩 Design Principles

- One example = one architectural goal
- Shared projects, ARM OIDC trust and variable groups composed through `terraform-az-fk-devops`
- GitHub source access supplied separately from Azure workload authentication
- Explicit permissions for an individual pipeline
- YAML owns stages, jobs, steps and trigger logic
- Provider credentials and secret values stay outside source control
- Static validation is reported separately from runtime deployment

These examples intentionally avoid:

- Creating the Azure DevOps organization or source repositories
- Creating GitHub source connections
- Generating YAML delivery logic or a plan/apply template
- Granting all-pipeline access
- Creating Azure role assignments, networking or deployment targets
- Sharing state or requiring Example 01 to be deployed before Example 02

---

## 🧩 Related Resources

- [FoggyKitchen Azure DevOps Pipeline Module (terraform-az-fk-devops-pipeline)](../)
- [FoggyKitchen Azure DevOps Module (terraform-az-fk-devops)](https://github.com/foggykitchen/terraform-az-fk-devops)
- [FoggyKitchen Azure RBAC Module (terraform-az-fk-rbac)](https://github.com/foggykitchen/terraform-az-fk-rbac)
- [FoggyKitchen Azure Key Vault Module (terraform-az-fk-key-vault)](https://github.com/foggykitchen/terraform-az-fk-key-vault)

Support expectations are documented in [SUPPORT.md](../SUPPORT.md).

---

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](../LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
