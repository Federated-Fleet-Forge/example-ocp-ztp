# example-ocp-ztp

Zero Touch Provisioning (ZTP) site configurations, cluster-specific policy inputs, extra manifests applied during or after provisioning, and optional pre-flight tooling. This repository is the Git source for cluster install and site-level customization in the reference architecture.

## Directory structure

- **`siteconfigs/`**  
  Per-site (or per-cluster) directories containing kustomizations, image sets, and ZTP-oriented manifests consumed by hub automation.

- **`extra-manifests/`**  
  Additional manifests referenced from site configs or provisioning flows where the reference pattern expects extra resources beyond the core install set.

- **`pre-flight/`**  
  Scripts, data, or utilities used to validate networking, labels, or prerequisites before cluster provisioning or policy rollout.

## Site configuration layout

Under each site directory (for example `siteconfigs/<cluster-name>/`), the reference typically includes:

- **`siteconfig.yaml`** — Primary site configuration consumed by the ZTP/siteconfig workflow.
- **`cluster-spec.yaml`** — Cluster specification and related install parameters aligned with your provisioning pipeline.
- **`policy-cluster-specific/`** — PolicyGenerator inputs, placements, and static configuration scoped to that cluster (for example NNCP, routes, or cluster-scoped network definitions), often built with Kustomize.

Exact file names may vary slightly by platform version; align with the kustomization entry points in each site folder.

## How this repository is used

Argo CD ApplicationSets configured in [example-ocp-gitops-base](https://github.com/dusty-seahorse/example-ocp-gitops-base) watch **`siteconfigs/`** (and related paths as defined in the bootstrap repo) so new or updated clusters are registered and reconciled from Git.

## Security and Access

Because Git RBAC is repository-wide, this repository is kept physically separate from the hub bootstrap (`example-ocp-gitops-base`). This split ensures that Network and Data Centre Teams can safely submit Pull Requests to manage day-to-day site changes (like updating a site's IP address, adding a new `SiteConfig`, or tweaking routes) without requiring admin access to the core GitOps engine or root App-of-Apps.

## Related documentation

- [example-ocp-gitops-base](https://github.com/dusty-seahorse/example-ocp-gitops-base) — Hub bootstrap, ApplicationSets, and [docs/architecture.md](https://github.com/dusty-seahorse/example-ocp-gitops-base/blob/main/docs/architecture.md)
