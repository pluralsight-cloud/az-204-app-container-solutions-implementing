var location = resourceGroup().location

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
