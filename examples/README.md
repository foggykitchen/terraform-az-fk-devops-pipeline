# Azure Pipelines with Terraform/OpenTofu – Training Examples

This directory contains all progressive examples used with the **terraform-az-fk-devops-pipeline** module.
The examples are designed as **incremental building blocks**, starting with a GitHub-sourced YAML pipeline definition and then introducing variable-group attachment and per-pipeline authorization.

These examples are part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses)** and focus on Azure Pipelines control-plane configuration.

**Pipeline delivery logic remains in caller-owned YAML.** Example 01 demonstrates container image build, HTTP smoke testing and image archive publication. Example 02 uses a placeholder to focus on variable-group wiring. Neither implements an OpenTofu plan/apply workflow.

---

## 🧭 Example Overview

| Example | Title | Key Topics |
|:-------:|:------|:-----------|
| [01](01_pipeline_definition_github_source/) | **Container Build with GitHub Source** | Upstream project/WIF/GitHub composition, YAML pointer, container build, smoke test, image archive artifact |
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
- An `azure-pipelines.yml` reference file; actual pipeline execution reads the source repository’s file

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

Read the selected example's Deployment Steps before provisioning it. Both require an existing Azure DevOps organization and subscription, bootstrap authentication and administration rights. The upstream module now creates the GitHub PAT source connection and supplies its ID to the pipeline module. Configure `AZDO_GITHUB_SERVICE_CONNECTION_PAT` externally; Terraform handles the creation order. The PAT is retained in state, which must be protected. Both examples pin the upstream Git dependency to the reviewed v0.2.0 commit. The ARM OIDC connection does not authenticate GitHub.

Both examples passed static validation with OpenTofu **1.11.6** on **October 14, 2026**. Initial verification used static checks only. Example 01 subsequently completed both its six-resource foundation apply and four-resource full apply. Its GitHub connectivity run #1 succeeded, followed by container build #4 with HTTP smoke test and published `APPLICATION_DOCKER_IMAGE`. ARM runtime OIDC exchange remains untested. Example 02 has not been deployed.

---

## 🧩 Design Principles

- One example = one architectural goal
- Shared projects, ARM OIDC trust and variable groups composed through `terraform-az-fk-devops`
- GitHub source access composed upstream and kept separate from Azure workload authentication
- Explicit permissions for an individual pipeline
- YAML owns stages, jobs, steps and trigger logic
- Provider credentials and secret values stay outside source control
- Static validation is reported separately from runtime deployment

These examples intentionally avoid:

- Creating the Azure DevOps organization or source repositories
- Declaring raw GitHub endpoint resources in example code; connections are composed through the upstream module
- Generating YAML delivery logic or a plan/apply template
- Granting all-pipeline access
- Creating Azure role assignments, networking or deployment targets; Example 01 creates only an empty Resource Group for external composition
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
