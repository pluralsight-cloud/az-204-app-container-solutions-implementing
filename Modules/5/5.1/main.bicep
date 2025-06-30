var location  = resourceGroup().location
var vmUsername = 'DevUser'
var vmPassword = 'SuperLongPassword12345'

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
