# Architecture

## High-Level Design

GitHub Actions deploys Azure infrastructure using Bicep. Authentication to Azure uses GitHub OIDC and Microsoft Entra workload identity federation, eliminating the need for stored secrets.

## Architecture Diagram

```mermaid
flowchart TD
    Dev[Developer] --> GitHub[GitHub Repository]
    GitHub --> Actions[GitHub Actions Workflow]
    Actions -->|OIDC Auth| Entra[Microsoft Entra ID]
    Entra --> Sub[Azure Subscription]

    Actions -->|az deployment group create| RG[Resource Group]

    subgraph RG[Azure Resource Group]
        LAW[Log Analytics Workspace]
        ACR[Azure Container Registry]
        KV[Azure Key Vault]
        AKS[Azure Kubernetes Service]
    end

    ACR -->|AcrPull Role| AKS
    LAW -->|OMS Agent| AKS
    AKS --> Pods[Application Pods]

    User[End User] --> LB[Load Balancer]
    LB --> Pods
```

## Components

### GitHub Actions

Responsible for validating and deploying Bicep templates. The workflow:

1. Checks out the repository
2. Authenticates to Azure using OIDC (no stored secrets)
3. Validates Bicep templates
4. Runs a what-if deployment for review
5. Deploys infrastructure incrementally

### Azure Resource Group

Environment-specific container for all platform resources. Naming convention: `rg-{project}-{environment}`.

### Azure Kubernetes Service (AKS)

Managed Kubernetes cluster for containerized workloads.

| Setting | Value |
|---|---|
| Identity | System-assigned managed identity |
| Network plugin | Azure CNI |
| Load balancer | Standard SKU |
| RBAC | Enabled |
| Monitoring | OMS agent connected to Log Analytics |
| Node pool | System pool with configurable count and VM size |

### Azure Container Registry (ACR)

Private container registry for application images.

| Setting | Value |
|---|---|
| SKU | Basic |
| Admin user | Disabled |
| Access | AKS identity granted AcrPull role |

### Azure Key Vault

Secure storage for application and platform secrets.

| Setting | Value |
|---|---|
| Authorization | Azure RBAC (no access policies) |
| Soft delete | 7 days retention |
| Purge protection | Disabled (suitable for dev/test) |
| Template deployment | Enabled |

### Log Analytics Workspace

Central logging and monitoring workspace for AKS.

| Setting | Value |
|---|---|
| SKU | PerGB2018 |
| Retention | 30 days |
| Integration | AKS OMS agent addon |

## Security Design

```mermaid
flowchart LR
    GH[GitHub Actions] -->|OIDC Token| Entra[Microsoft Entra ID]
    Entra -->|Access Token| ARM[Azure Resource Manager]
    ARM --> RG[Resource Group]

    AKS[AKS Managed Identity] -->|AcrPull| ACR[Container Registry]
    AKS -->|Key Vault access| KV[Key Vault via RBAC]
```

### Key Security Decisions

- **No client secrets in GitHub** — OIDC federated credentials are used instead of service principal secrets
- **System-assigned managed identity** — AKS uses a managed identity; no keys to rotate
- **ACR Pull role assignment** — AKS identity is explicitly granted pull access to ACR
- **Key Vault RBAC** — Azure RBAC authorization replaces access policies for better governance
- **Admin user disabled on ACR** — prevents password-based access to the registry

## Module Dependencies

```mermaid
flowchart TD
    Main[main.bicep] --> LAW[loganalytics.bicep]
    Main --> ACR[acr.bicep]
    Main --> KV[keyvault.bicep]
    Main --> AKS[aks.bicep]

    LAW -->|workspaceResourceId| AKS
    ACR -->|acrResourceId| AKS
```

The `main.bicep` orchestrator deploys modules in dependency order:

1. **Log Analytics** — deployed first (AKS depends on its resource ID)
2. **ACR** — deployed in parallel with Log Analytics (AKS depends on its resource ID)
3. **Key Vault** — deployed independently (no downstream dependencies yet)
4. **AKS** — deployed last (depends on Log Analytics and ACR outputs)

## Naming Convention

All resources follow the pattern: `{type}-{project}-{environment}`

| Resource | Naming Pattern | Example |
|---|---|---|
| Resource Group | `rg-{project}-{env}` | `rg-srelab-dev` |
| AKS Cluster | `aks-{project}-{env}` | `aks-srelab-dev` |
| Container Registry | `acr{project}{env}` | `acrsrelabdev` |
| Key Vault | `kv-{project}-{env}` | `kv-srelab-dev` |
| Log Analytics | `law-{project}-{env}` | `law-srelab-dev` |
