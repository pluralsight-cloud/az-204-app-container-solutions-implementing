@description('The tenant ID for the Service Principal (Application), use the default value for the Sandbox')
param tenantId string = '84f1e4ea-8554-43e1-8709-f0b8589ea118'
@description('The Client ID for the Service Principal (Application). Retrieve this value from the details of your Sandbox instance.')
param applicationClientId string
@secure()
@description('The Client Secret for the Service Principal (Application). Retrieve this value from the details of your Sandbox instance.')
param applicationClientSecret string

var uniqueSuffix = uniqueString(resourceGroup().id)
var location  = resourceGroup().location

resource appServicePlanWindows 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: 'asp-carvedrockfitness-windows'
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
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

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'ds-deploymentscript'
  location: location
  dependsOn: [
    srcControls
  ]
  kind: 'AzureCLI'
  properties: {
    forceUpdateTag: '1'
    azCliVersion:  '2.71.0'
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
      {
        name: 'APP_NAME'
        value: 'app-carvedrockfitness-windows-${uniqueSuffix}'
      }
    ]
    scriptContent: '''
    az login --service-principal --username $APP_ID --password $CLIENT_SECRET --tenant $TENANT_ID
    RG=$(az group list --query [].name --output tsv)
    LOCATION=$(az group list --query [].location --output tsv)
    az webapp deployment source delete --name $APP_NAME --resource-group $RG
    '''
    supportingScriptUris: []
    timeout: 'PT30M'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'PT1H'
  }
}
