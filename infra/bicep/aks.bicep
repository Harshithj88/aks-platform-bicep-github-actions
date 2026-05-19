@description('Name of the AKS cluster')
param aksName string

@description('Azure region for the AKS cluster')
param location string

@description('Kubernetes version. Leave empty to use Azure default.')
param kubernetesVersion string

@description('Number of nodes in the system pool')
param nodeCount int

@description('VM size for the system pool nodes')
param nodeVmSize string

@description('Resource ID of the Log Analytics workspace for monitoring')
param logAnalyticsWorkspaceResourceId string

@description('Resource ID of the Azure Container Registry for AcrPull role assignment')
param acrResourceId string

resource aks 'Microsoft.ContainerService/managedClusters@2025-08-01' = {
  name: aksName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: aksName

    kubernetesVersion: empty(kubernetesVersion) ? null : kubernetesVersion

    agentPoolProfiles: [
      {
        name: 'systempool'
        count: nodeCount
        vmSize: nodeVmSize
        osType: 'Linux'
        mode: 'System'
        type: 'VirtualMachineScaleSets'
      }
    ]

    enableRBAC: true

    networkProfile: {
      networkPlugin: 'azure'
      loadBalancerSku: 'standard'
    }

    addonProfiles: {
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: logAnalyticsWorkspaceResourceId
        }
      }
    }
  }
}

resource acrResource 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: last(split(acrResourceId, '/'))
}

resource acrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(aks.id, acrResourceId, 'AcrPull')
  scope: acrResource
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '7f951dda-4ed3-4680-a7ca-43fe172d538d'
    )
    principalId: aks.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

output aksClusterName string = aks.name
