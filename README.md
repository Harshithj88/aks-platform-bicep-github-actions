# AKS Platform with Bicep and GitHub Actions

## Overview

This project demonstrates a production-style Azure Kubernetes Service platform using Infrastructure as Code and CI/CD automation.

The platform is deployed using Azure Bicep and GitHub Actions with OIDC-based authentication to Azure.

## Architecture

The deployment provisions:

- Azure Kubernetes Service
- Azure Container Registry
- Azure Key Vault
- Azure Log Analytics Workspace
- Managed Identity
- AKS monitoring integration
- ACR Pull access for AKS
- Environment-specific parameter files

## Tech Stack

- Azure Kubernetes Service
- Azure Bicep
- GitHub Actions
- Azure Container Registry
- Azure Key Vault
- Log Analytics
- Kubernetes
- OIDC authentication

## Repository Structure

```text
infra/bicep      Bicep infrastructure modules
.github/workflows GitHub Actions deployment workflow
docs             Architecture and deployment documentation


---

# 14. Add architecture document

## `docs/architecture.md`

```markdown
# Architecture

## High-Level Design

GitHub Actions deploys Azure infrastructure using Bicep. Authentication to Azure uses GitHub OIDC and Microsoft Entra workload identity federation.

## Components

### GitHub Actions

Responsible for validating and deploying Bicep templates.

### Azure Resource Group

Environment-specific container for platform resources.

### Azure Kubernetes Service

Managed Kubernetes cluster used for containerized workloads.

### Azure Container Registry

Private container registry for application images.

### Azure Key Vault

Secure storage for application and platform secrets.

### Log Analytics

Central logging and monitoring workspace for AKS.

## Security Design

- No client secrets are stored in GitHub.
- GitHub uses OIDC authentication.
- AKS uses system-assigned managed identity.
- ACR Pull role is assigned to the AKS identity.
- Key Vault uses Azure RBAC authorization.