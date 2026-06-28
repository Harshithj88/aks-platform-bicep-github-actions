# Contributing

Thank you for your interest in contributing to this project.

## How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-addition`)
3. Make your changes
4. Run `az bicep build --file infra/bicep/main.bicep` to validate Bicep templates
5. Commit your changes (`git commit -m "Add: description of your change"`)
6. Push to your branch (`git push origin feature/your-addition`)
7. Open a pull request

## What to Contribute

- **Bicep modules** — new Azure resource modules or improvements to existing ones
- **Kubernetes manifests** — production-ready K8s configurations
- **GitHub Actions workflows** — CI/CD improvements
- **Documentation** — architecture docs, guides, diagrams
- **Security hardening** — network policies, RBAC configurations, best practices
- **Corrections** — fixing errors, outdated API versions, or broken configurations

## Guidelines

- Use Mermaid for architecture diagrams
- Follow the existing Bicep module structure and naming conventions
- All Bicep modules must pass `az bicep build` without errors
- Include `@description` decorators on all Bicep parameters
- Use Kubernetes manifests with explicit resource requests and limits
- Do not commit Azure credentials or secrets
- Use code blocks with language tags for all commands

## Naming Conventions

- Bicep files: lowercase with descriptive names (`vnet.bicep`, `keyvault.bicep`)
- K8s manifests: lowercase with hyphens (`network-policy.yaml`, `hpa.yaml`)
- Workflows: lowercase with hyphens (`deploy-infra.yml`, `validate-bicep.yml`)
