# terraform-az-fk-devops-pipeline

This repository contains a reusable **Terraform / OpenTofu module** and progressive examples for registering **Azure Pipelines YAML definition pointers and their individual resource permissions**.

It is part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses)** and composes with the required upstream [terraform-az-fk-devops](https://github.com/foggykitchen/terraform-az-fk-devops), which owns projects, ARM OIDC service connections and variable groups.

**Pipeline stages, jobs, steps, approvals, deployment patterns and trigger logic live in caller-owned YAML or external resource policies. This module accepts a YAML file path only. It never models or generates pipeline YAML content.** A reference OpenTofu plan/apply YAML template is outside this module’s scope.

Support expectations are documented in [SUPPORT.md](SUPPORT.md).

---

## Used By

This module is intended as a focused building block for higher-level [FoggyKitchen Landing Zone Orchestrator](https://github.com/foggykitchen/foggykitchen-landing-zone-orchestrator) compositions.

## 🎯 Purpose

Register one YAML-based pipeline per module call and authorize it to use existing shared control-plane resources. Azure differs deliberately from [terraform-oci-fk-devops-pipeline](https://github.com/foggykitchen/terraform-oci-fk-devops-pipeline): OCI exposes its stage graph as Terraform resources; Azure YAML pipeline execution logic is owned by the repository's YAML file. No stage graph inputs or YAML content outputs exist here.

---

## ✨ What the module does

The module creates:

- One `azuredevops_build_definition` pointing to an existing repository, branch and YAML file
- Individual `azuredevops_pipeline_authorization` entries for the upstream ARM endpoint and, with GitHub, its separate source endpoint
- Optional variable-group definition attachments and individual `variablegroup` authorizations
- A CI settings selector delegating to YAML by default, or disabling definition CI without defining trigger filters

The module intentionally does **not** create:

- Pipeline stages, jobs, steps or trigger logic, including plan/apply, canary or blue-green workflows
- Classic/designer pipelines, despite the provider exposing classic `jobs` on the same resource
- Azure DevOps projects, service connections or variable groups; use the upstream module for shared ARM/WIF resources and groups
- GitHub source connections; register these independently before supplying their IDs
- YAML pipeline file content; only its repository-relative path is accepted
- Source repositories, Azure resources, Azure role assignments, environments or approval/check policies

**All delivery logic remains in YAML.** The examples commit only trivial placeholder files so the referenced paths exist; they are not deployment templates.

---

## Provider Notes

The module pins **microsoft/azuredevops = 1.16.0**, matching `terraform-az-fk-devops`. The provider schema was verified on **October 14, 2026**. Terraform/OpenTofu **>= 1.5.0** matches the upstream minimum. Only the examples need **hashicorp/azuread = 3.10.0** to compose the upstream module; no AzureRM provider is used.

The [provider resource](https://github.com/microsoft/terraform-provider-azuredevops/blob/v1.16.0/website/docs/r/build_definition.html.markdown) requires `project_id`, `name` and `repository { repo_type, repo_id }`. It also supports `branch_name`, `yml_path` and source `service_connection_id`. This module strengthens those requirements with an explicit nonblank YAML path, branch default `main`, and source-specific validations. It exposes no classic jobs. Initial automatic execution is suppressed with `features.skip_first_run = true`.

### Source repository choice

`repository.type` defaults to `GitHub`, matching this organization's examples. Supply `id = "owner/repository"` and `repository.service_connection_id` for an existing GitHub endpoint in the same Azure DevOps project. This is distinct from top-level `service_connection_id`, which is the upstream **Azure Resource Manager OIDC** endpoint. ARM federation does not provide GitHub source access.

For Azure Repos, set `type = "TfsGit"`, supply the existing repository UUID, and omit `repository.service_connection_id`. A repository name can be resolved by the caller's `azuredevops_git_repository` data source; this module takes its ID. Branch names may use `main` or `refs/heads/main`; provider 1.16.0 normalizes the prefix. GitHub Enterprise, generic Git and Bitbucket are outside this module's supported source contract.

Install/configure GitHub App access externally, or independently manage a supported source endpoint. The [GitHub endpoint provider documentation](https://github.com/microsoft/terraform-provider-azuredevops/blob/v1.16.0/website/docs/r/serviceendpoint_github.html.markdown) explains PAT support and external OAuth/App setup/import requirements. No source credentials are accepted by this module.

### CI selector and YAML ownership

`ci_trigger_use_yaml = true` sets `ci_trigger.use_yaml = true`: YAML owns CI configuration, including branch/path filters and `trigger: none`. False omits the CI block and sends an empty definition trigger list. For explicit YAML CI suppression, author `trigger: none` in the caller-owned file and check organization implied-CI settings. This is a definition CI selector, not a global run-disable switch: manual runs and other run causes/policies are separate. The provider also supports trigger overrides, schedules and classic jobs; this module intentionally exposes none of that logic. Neither value changes the YAML's stages, jobs or steps. Real organization behavior has not been runtime-tested.

### Resource permissions and variable groups

The [authorization resource](https://github.com/microsoft/terraform-provider-azuredevops/blob/v1.16.0/website/docs/r/pipeline_authorization.html.markdown) registers `endpoint` and `variablegroup` access with this definition's explicit `pipeline_id`. The module never grants all-pipeline access. Stable logical keys allow generated endpoint/group IDs to remain unknown until deployment.

`variable_group_ids` attaches IDs to definition metadata and authorizes each group. **For YAML pipelines, the caller must still reference the group name in its own YAML**; metadata attachment is not a generated YAML declaration or guarantee of runtime variable injection. Secret groups are protected resources; Microsoft's [group guidance](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups?view=azure-devops) notes nonsecret variables are not restricted by those checks. Example 02 uses nonsecret configuration to demonstrate the permission wiring without secret fixtures.

Keep upstream groups' `allow_access = false`. Existing all-pipeline grants take precedence over individual grants and are not revoked by this module. Endpoint permissions do not grant Azure RBAC, GitHub App repository access, or satisfy external approval/check policies. Existing organization policies may still require manual approval. With sufficient bootstrap administration permissions, these specific pipeline resource grants are Terraform-manageable; a manual first-run permission click is not the only mechanism.

### Prerequisites and authentication

- Existing Azure DevOps organization and shared upstream resources; all supplied resources must belong to the expected project.
- Existing repository and YAML file on the selected remote branch. A local file or local commit does not publish it to GitHub/Azure Repos.
- Existing GitHub source endpoint with repository access when using GitHub.
- Bootstrap rights to create/edit definitions and manage the referenced resources' pipeline permissions. Use the AzureDevOps provider's documented external authentication; `AZDO_ORG_SERVICE_URL` can supply the organization URL. Inject any bootstrap credentials through secure environment configuration.
- For upstream composition, externally configure AzureAD authentication and directory creation/ownership permissions. The new ARM connection does not authenticate the initial OpenTofu run.
- Future Azure workloads need separately assigned Azure RBAC. Authorization here allows pipeline use of a connection; it grants no subscription role.

No credentials, secrets, state or real tfvars belong in Git. Static validation does not verify live service permissions, branch/file existence, OIDC exchange or pipeline execution.

---

## 📂 Repository Structure

```text
terraform-az-fk-devops-pipeline/
├── examples/
│   ├── 01_pipeline_definition_github_source/
│   ├── 02_pipeline_with_variable_group_authorization/
│   └── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── SUPPORT.md
├── LICENSE
├── .gitignore
└── README.md
```

Examples use responsibility-named `devops.tf` and `pipeline.tf`, plus `providers.tf`, `variables.tf`, `outputs.tf`, `terraform.tfvars.example`, `README.md` and a minimal `azure-pipelines.yml` placeholder. Lockfiles and state are ignored.

---

## 🚀 Example Usage

After composing the upstream module as `module.devops` and independently registering the GitHub source endpoint:

```hcl
module "pipeline" {
  source = "./terraform-az-fk-devops-pipeline"

  project_id            = module.devops.project_id
  pipeline_name         = "fk-delivery"
  service_connection_id = module.devops.service_connection_id
  repository = {
    id                    = "your-organization/your-repository"
    service_connection_id = var.github_service_connection_id
  }
  yaml_path          = "azure-pipelines.yml"
  variable_group_ids = module.devops.variable_group_ids
}
```

The local source path assumes this module has been checked out at that location. The numbered examples use `../..` and pin upstream composition to a reviewed commit. A fresh project's GitHub endpoint needs staged bootstrap; see the example READMEs.

For an existing Azure Repos source, replace `repository` with:

```hcl
repository = {
  type = "TfsGit"
  id   = var.existing_azure_repos_repository_id
}
```

---

## 📥 Module Inputs

| Variable | Type | Required | Default | Description |
|---|---|:---:|---|---|
| `project_id` | `string` | yes | — | Existing Azure DevOps project ID from terraform-az-fk-devops. |
| `pipeline_name` | `string` | yes | — | Name of the YAML pipeline definition. |
| `repository` | `object` | yes | — | Existing source repository: GitHub owner/repository plus source endpoint, or TfsGit repository UUID. |
| `yaml_path` | `string` | yes | — | Repository-relative path to an existing YAML pipeline file; content is caller-owned. |
| `service_connection_id` | `string` | yes | — | Existing ARM OIDC service connection ID from terraform-az-fk-devops to authorize for this pipeline. |
| `variable_group_ids` | `map(number)` | no | `{}` | Existing variable group IDs keyed by stable logical name; attached and authorized for this pipeline. |
| `ci_trigger_use_yaml` | `bool` | no | `true` | Delegate CI to YAML when true; false removes definition CI without adding trigger logic. |

See [variables.tf](variables.tf) for the exact nested object schema and validations. All top-level inputs reject null. `repository` requires `id`; optional `type` defaults `GitHub`, `branch_name` defaults `main`, and `service_connection_id` defaults null. GitHub requires owner/repository plus an endpoint UUID; TfsGit requires a repository UUID and no endpoint. Project/ARM IDs must be UUIDs; names/branch/path must be nonblank. YAML paths must be relative without parent traversal. Group IDs must be unique positive integers and keys nonblank. Upstream string-valued numeric group IDs convert to this module's `map(number)`.

---

## 📤 Module Outputs

| Output | Description |
|---|---|
| `pipeline_id` | YAML pipeline definition ID, ready after endpoint and variable-group permissions are registered. |
| `pipeline_name` | YAML pipeline definition name. |
| `project_id` | Azure DevOps project ID used by the pipeline. |

`pipeline_id` waits for permission resources, which establishes dependency ordering rather than a runtime readiness guarantee. No YAML content, stage, job, step or trigger-logic outputs exist.

---

## 🧭 Examples

- [01_pipeline_definition_github_source](examples/01_pipeline_definition_github_source/): minimal GitHub pointer with upstream project/WIF outputs and an existing source endpoint.
- [02_pipeline_with_variable_group_authorization](examples/02_pipeline_with_variable_group_authorization/): adds upstream nonsecret group attachment and per-pipeline authorization, demonstrating attachment and explicit permission as separate control-plane operations.

See [examples](examples/README.md). Both placeholders contain no plan/apply or OIDC deployment logic.

---

## 🧠 Design Philosophy

- Shared projects, identity trust and groups remain upstream responsibilities.
- Terraform registers YAML pointers and per-pipeline permissions.
- YAML owns the delivery graph and trigger logic.
- Repositories, source endpoints, Azure RBAC and approval policies have separate owners.

### Typical Integration Pattern

1. Configure the organization and bootstrap provider authentication externally.
2. Create project/WIF trust and optional groups with `terraform-az-fk-devops`.
3. Register source-host access externally; publish caller-owned YAML in the repository.
4. Call this module with the upstream IDs, source endpoint and YAML path.
5. Grant workload-specific Azure RBAC externally and author delivery logic in the source repository’s YAML.

---

## ✅ Test Results

Static verification completed on **October 14, 2026** with OpenTofu **1.11.6**:

| Configuration | `tofu fmt -check` | `tofu init -backend=false` | `tofu validate` |
|---|:---:|:---:|:---:|
| Root module | Passed | Passed | Passed |
| Example 01 | Passed | Passed | Passed |
| Example 02 | Passed | Passed | Passed |

Both placeholder YAML files passed syntax checks. No plan, apply or pipeline execution was performed. Static validation does not verify remote YAML availability, organization permissions or runtime OIDC authentication.

---

## 🧩 Related Modules & Training

- [terraform-az-fk-devops](https://github.com/foggykitchen/terraform-az-fk-devops) — required shared control-plane dependency
- [terraform-oci-fk-devops-pipeline](https://github.com/foggykitchen/terraform-oci-fk-devops-pipeline) — OCI positioning counterpart; different resource graph ownership
- [terraform-az-fk-rbac](https://github.com/foggykitchen/terraform-az-fk-rbac)
- [terraform-az-fk-key-vault](https://github.com/foggykitchen/terraform-az-fk-key-vault)

---

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
