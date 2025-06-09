var location  = resourceGroup().location
var uniqueSuffix = uniqueString(resourceGroup().id)
var roleDefinitionId = {
  Contributor: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  }
}

resource appServicePlanWindows 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: 'asp-carvedrockfitness-windows'
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
  }
  properties: {
    reserved: false
  }
}

resource windowsWebApplication 'Microsoft.Web/sites@2022-03-01' = {
  name: 'app-carvedrockfitness-windows-${uniqueSuffix}'
  location: location
  properties: {
    serverFarmId: appServicePlanWindows.id
  }
}

resource srcControls 'Microsoft.Web/sites/sourcecontrols@2021-01-01' =  {
  parent: windowsWebApplication
  name: 'web'
  properties: {
    repoUrl: 'https://github.com/WayneHoggett-ACG/CarvedRockFitness'
    branch: 'main'
    isManualIntegration: true
  }
}

resource appServicePlanLinux 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: 'asp-carvedrockfitness-linux'
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
    size: 'S1'
    family: 'S'
    capacity: 1
  }
  properties: {
    reserved: true
  }
  kind: 'linux'
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'app-carvedrockfitness-container-${uniqueSuffix}'
  location: location
  dependsOn: [
    deploymentScript
  ]
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlanLinux.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistry.properties.loginServer}/carvedrockfitness:latest'
      appSettings: [
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://${containerRegistry.properties.loginServer}'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: containerRegistry.listCredentials().username
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: containerRegistry.listCredentials().passwords[0].value
        }
      ]
    }
  }
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2025-04-01' = {
  name: 'cr${uniqueSuffix}'
  location: resourceGroup().location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

resource deploymentScriptIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'DeploymentScriptIdentity'
  location: location
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(deploymentScriptIdentity.id, resourceGroup().id, 'Contributor')
  scope: resourceGroup()
  properties: {
    description: 'Managed identity role assignment'
    principalId: deploymentScriptIdentity.properties.principalId
    roleDefinitionId: roleDefinitionId.Contributor.id
    principalType: 'ServicePrincipal'
  }
}

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'ds-deploymentscript'
  location: location
  dependsOn: [
    roleAssignment
  ]
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${deploymentScriptIdentity.id}': {}
    }
  }
  properties: {
    forceUpdateTag: '1'
    azCliVersion:  '2.9.1' //Not 2.71.0
    scriptContent: '''
    RG=$(az group list --query [].name --output tsv)
    ACR=$(az acr list --resource-group $RG --query [].name --output tsv)
    git clone https://github.com/WayneHoggett-ACG/CarvedRockFitness.git
    cd CarvedRockFitness
    az acr build --registry $ACR --image carvedrockfitness .
    '''
    supportingScriptUris: []
    timeout: 'PT30M'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'PT1H'
  }
}
