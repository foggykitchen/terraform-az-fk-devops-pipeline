# Example 01: Pipeline Definition with GitHub Source

In this first Azure Pipelines example, we register a **GitHub-sourced YAML pipeline definition** using **Terraform / OpenTofu**.

The example composes **terraform-az-fk-devops** with the local pipeline module. Shared project and ARM federation resources are created upstream; an existing GitHub source connection supplies repository access.

---

## 🧭 Architecture Overview

The pipeline definition points at `azure-pipelines.yml` on the `master` branch of [foggykitchen-hello-world](https://github.com/foggykitchen/foggykitchen-hello-world). Separate endpoint permissions allow this pipeline to use the GitHub source connection and the upstream ARM OIDC connection.

```mermaid
flowchart LR
    D[FK DevOps module] --> P[Azure DevOps project]
    D --> A[ARM OIDC connection and federated trust]
    G[Existing GitHub source connection] --> B[YAML pipeline definition]
    R[Existing GitHub repository] --> Y[Committed placeholder YAML]
    Y --> B
    P --> B
    B --> E[Individual endpoint permissions]
    A --> E
    G --> E
```

This example creates:

- One Azure DevOps project through `terraform-az-fk-devops`
- One Entra application/service principal, ARM WIF connection and federated credential through the upstream module
- One Azure Resource Group in `resource_group.tf`
- One YAML pipeline definition through the local `terraform-az-fk-devops-pipeline` module
- Individual pipeline permissions for the existing GitHub source endpoint and upstream ARM endpoint

The organization, subscription, GitHub repository and GitHub source endpoint already exist. No source repository, Azure role assignment, networking or deployment target is created.

**Stages, jobs, steps and trigger logic remain in YAML.** The local `azure-pipelines.yml` is a reference copy of the minimal placeholder in the source repository, with CI and PR triggers disabled and a single `Hello World` echo step. The definition reads the remote file, not this local copy. It contains no OpenTofu plan/apply or OIDC login logic and does not use the ARM connection.

---

## 🎯 Why this example exists

Before introducing shared configuration, it is useful to understand **how the project, source connection, YAML path and pipeline permissions fit together**.

This example focuses on:

- Registering a YAML definition without modeling its stage graph
- Passing upstream `project_id` and `service_connection_id` outputs
- Separating GitHub source access from ARM workload authentication
- Authorizing only the registered pipeline to use each endpoint
- Referencing a committed repository-relative YAML path

---

## 🚀 Deployment Steps

### Prerequisites

- An existing Azure DevOps organization and subscription
- Rights to create projects, ARM connections and pipeline definitions, and to manage individual pipeline resource permissions
- Entra rights to create/manage applications, service principals and federated credentials
- Bootstrap authentication configured externally for the AzureDevOps, AzureAD and AzureRM providers
- Permission to create the example Resource Group in the selected subscription
- A GitHub source connection in this example's project with access to the referenced repository
- The placeholder YAML published on the repository's selected remote branch

Copy `terraform.tfvars.example` to ignored `terraform.tfvars` and replace the nonsecret placeholder identifiers. Keep provider credentials outside HCL and tfvars. The GitHub endpoint ID and ARM endpoint ID identify different resources.

### Stage 1 — Prepare the project and source access

For a fresh environment, provision the upstream resources declared in `devops.tf` as a separate bootstrap stage before registering the pipeline. The project name is `fk-pipeline-01`. Register a GitHub App/service connection in that project through an independently managed setup, then set `github_service_connection_id` to its ID. A connection from another project is not a substitute.

The configuration requires this staged prerequisite; it does not create a GitHub endpoint automatically. When upstream resources are already managed in this example's state, retain that ownership. Avoid creating a second project with the same name in a separate state without reconciling ownership.

Publish the referenced [`azure-pipelines.yml`](https://github.com/foggykitchen/foggykitchen-hello-world/blob/master/azure-pipelines.yml) on the remote `master` branch of `foggykitchen-hello-world`. The OCI `build_spec.yaml` is independently owned and is not used by Azure Pipelines. A local file or local commit alone does not make the path available to Azure DevOps.

### Stage 2 — Validate the pipeline configuration

From this example directory:

```bash
cp terraform.tfvars.example terraform.tfvars
# Replace the nonsecret placeholder identifiers before deployment.
tofu init -backend=false
tofu fmt -check
tofu validate
```

`devops.tf` composes the upstream module at a reviewed commit. `pipeline.tf` uses the local root module source `../..`. `providers.tf`, `variables.tf` and `outputs.tf` provide the example wrapper. The pipeline definition suppresses its initial automatic run.

Full provisioning follows after the source prerequisites are ready and the configuration has been reviewed. The foundation stage has been deployed; the pipeline stage remains pending. The example creates its Resource Group using `resource_group_name` and `location`; `resource_group_id` is an external composition point. The ARM connection grants no Azure RBAC; compose the dedicated RBAC module externally when a future workload needs subscription access.

---

## 🖼️ Azure DevOps Portal View

The project, ARM WIF trust and Resource Group have been deployed. No screenshots have been collected yet; the pipeline definition and its permissions are pending GitHub source setup.

After an authorized deployment, inspect the project’s **Pipelines** view for `fk-pipeline-01`, its GitHub repository, selected branch and YAML path. Inspect **Project settings → Service connections → Pipeline permissions** for both endpoint grants.

Portal configuration evidence should be recorded separately from a successful pipeline run or OIDC token exchange.

---

## ✅ Test Results

Static verification completed on **October 14, 2026** with OpenTofu **1.11.6**:

| Check | Result |
|---|---|
| `tofu fmt -check` | Passed |
| `tofu init -backend=false` | Passed |
| `tofu validate` | Passed |
| Placeholder YAML syntax | Passed |

Initial verification used static checks only. A subsequent user-authorized foundation apply on **October 14, 2026** completed successfully:

```text
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.
```

This bootstrap created the project, Entra application/service principal, ARM WIF connection, federated credential and Resource Group. It targeted only `module.devops` and `azurerm_resource_group.foggykitchen_rg` because the GitHub source endpoint must be registered in the new project before the pipeline can be created. The full configuration has not yet been applied. No pipeline run or runtime OIDC exchange has been tested.

Static checks validate configuration and provider schema; they do not verify remote YAML availability or runtime permissions.

The example outputs expose `project_id`, `service_connection_id`, `pipeline_id` and `resource_group_id`. The pipeline ID output waits for its endpoint and variable-group permission resources. This establishes dependency ordering, not a guarantee of runtime readiness.

---

## 🧹 Cleanup

The foundation apply created six managed resources. They remain deployed for the pipeline test; cleanup has not been performed.

After a future deployment, review project contents and source-connection ownership before destroying the example. The configuration manages the project, Entra identity, ARM connection, federated trust, Resource Group, pipeline definition and its individual permissions. Review Resource Group contents before deletion. Project deletion can also remove contents added independently, including the GitHub source endpoint. The GitHub repository, Azure DevOps organization and Azure subscription remain externally managed.

---

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](../../LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
