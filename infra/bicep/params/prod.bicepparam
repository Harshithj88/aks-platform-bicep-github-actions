using '../main.bicep'

param environment = 'prod'
param location = 'eastus'
param projectName = 'srelab'
param kubernetesVersion = ''
param nodeCount = 2
param nodeVmSize = 'Standard_B2s'
