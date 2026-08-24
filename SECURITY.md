# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it responsibly:

1. **Do not** open a public GitHub issue
2. Email [harsh.julapelli@gmail.com](mailto:harsh.julapelli@gmail.com) with details
3. You will receive a response within 48 hours

## Security Design

- **OIDC federation** — GitHub Actions authenticates to Azure via federated identity; no stored secrets
- **Managed identities** — AKS uses system-assigned managed identity; no service principal keys
- **Private networking** — VNet-integrated AKS with NSG rules and private ACR access
- **Key Vault RBAC** — Secrets accessed via RBAC, not access policies
- **Least privilege** — Scoped role assignments per resource group
- **No public IPs** — Workload nodes are not internet-facing

## Sensitive Data

- Never commit Azure subscription IDs, tenant IDs, or client secrets
- Parameter files (`.bicepparam`) in this repo use placeholder values
- Real values should be passed via GitHub Actions secrets or Azure Key Vault
