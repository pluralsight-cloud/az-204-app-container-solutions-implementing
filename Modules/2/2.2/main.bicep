@description('The tenant ID for the Service Principal (Application), use the default value for the Sandbox')
param tenantId string = '84f1e4ea-8554-43e1-8709-f0b8589ea118'
@description('The Client ID for the Service Principal (Application). Retrieve this value from the details of your Sandbox instance.')
param applicationClientId string
@secure()
@description('The Client Secret for the Service Principal (Application). Retrieve this value from the details of your Sandbox instance.')
param applicationClientSecret string

var location  = resourceGroup().location
var uniqueSuffix = uniqueString(resourceGroup().id)

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
  name: 'app-carvedrockfitness-windows'
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

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'ds-deploymentscript'
  location: location
  dependsOn: [
    appServicePlanWindows
  ]
  kind: 'AzureCLI'
  properties: {
    forceUpdateTag: '1'
    azCliVersion:  '2.9.1' //Not 2.71.0
    environmentVariables: [
      {
        name: 'APP_ID'
        value: applicationClientId
      }
      {
        name: 'CLIENT_SECRET'
        value: applicationClientSecret
      }
      {
        name: 'TENANT_ID'
        value: tenantId
      }
    ]
    scriptContent: '''
    az login --service-principal --username $APP_ID --password $CLIENT_SECRET --tenant $TENANT_ID
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
