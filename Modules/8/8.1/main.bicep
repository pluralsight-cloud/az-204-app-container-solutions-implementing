
var uniqueSuffix = uniqueString(resourceGroup().id)
var sqlServerName  = 'sql-crf-${uniqueSuffix}'
var sqlAdministratorLogin = 'sqlAdmin'
var sqlAdministratorLoginPassword  = 'SuperSecretPassword1234'
var databaseName = 'carvedrockfitnessdb'

var location  = resourceGroup().location
var vmUsername = 'DevUser'
var vmPassword = 'SuperLongPassword12345'

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

resource firewallRules 'Microsoft.Sql/servers/firewallRules@2023-08-01' = {
  parent: sqlServer
  name: 'allow-all'
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '255.255.255.255'
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


resource vnet 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'vnet1'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet1'
        properties:{
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
            id: nsg1.id
          }
        }
      }
    ]
  }
}
resource nsg1 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'nsg1'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowAnyRDPInbound'
        properties: {
          description: 'Allow inbound RDP traffic from the Internet'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource DevVMPIP 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: 'pip-1-DevVM'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource DevVMNIC 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: 'nic-DevVM'
  location: location
  properties: {
          ipConfigurations: [
            {
              name: 'ipconfig-1-nic-1-DevVM'
              properties: {
                privateIPAllocationMethod: 'Dynamic'
                publicIPAddress: {
                  id: DevVMPIP.id
                }
                subnet: {
                  id: vnet.properties.subnets[0].id
                }
              }
            }
          ]
  }
}

resource DevVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: 'DevVM'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'standard_d2s_v5'
    }
    osProfile: {
      computerName: 'DevVM'
      adminUsername: vmUsername
      adminPassword: vmPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-g2'
        version: 'latest'
      }
      osDisk: {
        name: 'DevVM-OSDisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: DevVMNIC.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
  }
}

resource DevVMCSE 'Microsoft.Compute/virtualMachines/extensions@2020-12-01' = {
  parent: DevVM
  name: 'cse-DevVM'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    protectedSettings: {
      fileUris: [
        'https://gist.githubusercontent.com/WayneHoggett-ACG/1081923512900b33937c461158734c0f/raw/Set-ServerlessDeveloperVM.ps1'
      ]
      commandToExecute: 'powershell.exe -ExecutionPolicy Bypass -File Set-ServerlessDeveloperVM.ps1'
    }
  }
}
