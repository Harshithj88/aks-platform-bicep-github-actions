@description('Azure Container Registry name (must be globally unique, alphanumeric)')
@minLength(5)
@maxLength(50)
param acrName string

@description('Azure region')
param location string = resourceGroup().location

@description('SKU for the container registry')
@allowed(['Basic', 'Standard', 'Premium'])
param sku string = 'Premium'

@description('Enable admin user for the registry')
param adminUserEnabled bool = false

@description('Enable public network access')
param publicNetworkAccess bool = false

@description('Enable zone redundancy (Premium SKU only)')
param zoneRedundancy bool = true

@description('Number of days to retain untagged manifests')
param retentionDays int = 30

@description('Enable soft-delete for artifacts')
param softDeleteEnabled bool = true

@description('Soft-delete retention days')
param softDeleteRetentionDays int = 7

@description('Tags to apply')
param tags object = {}

resource acr 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: adminUserEnabled
    publicNetworkAccess: publicNetworkAccess ? 'Enabled' : 'Disabled'
    zoneRedundancy: (sku == 'Premium' && zoneRedundancy) ? 'Enabled' : 'Disabled'
    policies: {
      retentionPolicy: {
        status: 'enabled'
        days: retentionDays
      }
      softDeletePolicy: {
        status: softDeleteEnabled ? 'enabled' : 'disabled'
        retentionDays: softDeleteRetentionDays
      }
      trustPolicy: {
        status: 'enabled'
        type: 'Notary'
      }
    }
    networkRuleBypassOptions: 'AzureServices'
  }
  tags: tags
}

@description('Container Registry resource ID')
output id string = acr.id

@description('Container Registry name')
output name string = acr.name

@description('Container Registry login server')
output loginServer string = acr.properties.loginServer
