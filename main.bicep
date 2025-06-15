targetScope = 'resourceGroup'

param location string = 'eastus'
param prefix string = 'demo'

module hub 'hubVnet.bicep' = {
  name: '${prefix}-hub'
  params: {
    location: location
    prefix: prefix
  }
}

module spoke1 'spokeVnet.bicep' = {
  name: '${prefix}-spoke1'
  params: {
    location: location
    prefix: '${prefix}spoke1'
    addressPrefix: '10.1.0.0/16'
    hubVnetId: hub.outputs.vnetId
  }
}

module spoke2 'spokeVnet.bicep' = {
  name: '${prefix}-spoke2'
  params: {
    location: location
    prefix: '${prefix}spoke2'
    addressPrefix: '10.2.0.0/16'
    hubVnetId: hub.outputs.vnetId
  }
}

module fwRules 'firewallRules.bicep' = {
  name: '${prefix}-fwrules'
  params: {
    location: location
    firewallName: hub.outputs.firewallName
  }
}
