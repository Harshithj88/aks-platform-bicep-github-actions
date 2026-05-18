param keyVaultName string
param location string

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: toLower(keyVaultName)
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableRbacAuthorization: true
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: true
    softDeleteRetentionInDays: 7
    enablePurgeProtection: false
  }
}

output keyVaultUri string = keyVault.properties.vaultUri
