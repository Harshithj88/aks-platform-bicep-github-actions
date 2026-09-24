@description('Name of the resource to lock. Used to construct the lock name.')
param resourceName string

@description('Lock level to apply')
@allowed([
  'CanNotDelete'
  'ReadOnly'
])
param lockLevel string = 'CanNotDelete'

@description('Notes describing why the lock exists')
param notes string = 'Managed by Bicep — prevents accidental changes to critical infrastructure.'

// Resource-group-scoped lock. Deploy this module with a scope targeting the
// resource group (or a specific resource) you want to protect.
resource lock 'Microsoft.Authorization/locks@2020-05-01' = {
  name: '${resourceName}-${toLower(lockLevel)}-lock'
  properties: {
    level: lockLevel
    notes: notes
  }
}

@description('Resource ID of the created management lock')
output lockId string = lock.id

@description('Name of the created management lock')
output lockName string = lock.name
