@description('The tenant ID for the Service Principal (Application), use the default value for the Sandbox')
param tenantId string = '84f1e4ea-8554-43e1-8709-f0b8589ea118'
@description('The Client ID for the Service Principal (Application). Retrieve this value from the details of your Sandbox instance.')
param applicationClientId string
@secure()
@description('The Client Secret for the Service Principal (Application). Retrieve this value from the details of your Sandbox instance.')
param applicationClientSecret string
var location  = resourceGroup().location
var uniqueSuffix = uniqueString(resourceGroup().id)
var sqlServerName  = 'sql-crf-${uniqueSuffix}'
var sqlAdministratorLogin = 'sqlAdmin'
var sqlAdministratorLoginPassword  = 'SuperSecretPassword1234'
var databaseName = 'carvedrockfitnessdb'

resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: sqlServerName
  location: location
  tags: {
    displayName: 'SQL Server'
  }
  properties: {
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorLoginPassword
    version: '12.0'
  }
}

resource firewallRules 'Microsoft.Sql/servers/firewallRules@2022-02-01-preview' = {
  parent: sqlServer
  name: 'firewallRules'
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  parent: sqlServer
  name: databaseName
  location: location
  tags: {
    displayName: 'Database'
  }
  sku: {
    name: 'Basic'
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 1073741824
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

resource config 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: windowsWebApplication
  name: 'web'
  properties: {
    connectionStrings: [
      {
        name: 'DefaultConnection'
        connectionString: 'Server=${sqlServerName}.database.windows.net;Database=${databaseName};User Id=${sqlAdministratorLogin};Password=${sqlAdministratorLoginPassword};'
        type: 'SQLAzure'
      }
    ]
    netFrameworkVersion: 'v8.0'
    webSocketsEnabled: true
  }
}

resource appServicePlanLinux 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: 'asp-carvedrockfitness-linux'
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    family: 'B'
    capacity: 1
  }
  properties: {
    reserved: true
  }
  kind: 'linux'
}

resource containerWebApplication 'Microsoft.Web/sites@2022-03-01' = {
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
    az acr build --registry $ACR --image carvedrockfitness .
    '''
    supportingScriptUris: []
    timeout: 'PT30M'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'PT1H'
  }
}
