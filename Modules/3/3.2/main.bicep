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
  }
}
