@description('Name of the Azure Container Registry')
param acrName string

@description('Azure region for the Container Registry')
param location string

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: toLower(acrName)
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: false
  }
}

output acrResourceId string = acr.id
output acrLoginServer string = acr.properties.loginServer