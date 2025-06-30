@description('The tenant ID for the Service Principal (Application), use the default value for the Sandbox')
param tenantId string = '84f1e4ea-8554-43e1-8709-f0b8589ea118'
@description('The Client ID for the Service Principal (Application). Retrieve this value from the details of your Sandbox instance.')
param applicationClientId string
@secure()
@description('The Client Secret for the Service Principal (Application). Retrieve this value from the details of your Sandbox instance.')
param applicationClientSecret string


var location  = resourceGroup().location
var uniqueSuffix = uniqueString(resourceGroup().id)

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name: 'acrcrf${uniqueSuffix}'
  location: location
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
    containerRegistry
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
    az acr build --registry $ACR --image crf:v1 .
    '''
    supportingScriptUris: []
    timeout: 'PT30M'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'PT1H'
  }
}
