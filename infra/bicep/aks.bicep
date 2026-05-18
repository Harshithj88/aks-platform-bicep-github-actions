param aksName string
param location string
param kubernetesVersion string
param nodeCount int
param nodeVmSize string
param logAnalyticsWorkspaceResourceId string
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

resource acrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(aks.id, acrResourceId, 'AcrPull')
  scope: resourceGroup()
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
