param location string
param prefix string

var hubVnetName = '${prefix}-hub-vnet'
var firewallName = '${prefix}-azfw'
var firewallPipName = '${prefix}-fw-pip'
var routeTableName = '${prefix}-rt'

resource hubVnet 'Microsoft.Network/virtualNetworks@2022-09-01' = {
  name: hubVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet' // Must be exactly this name
        properties: {
          addressPrefix: '10.0.1.0/26'
        }
      }
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.0.2.0/27'
        }
      }
    ]
  }
}

resource firewallPip 'Microsoft.Network/publicIPAddresses@2022-09-01' = {
  name: firewallPipName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource azureFirewall 'Microsoft.Network/azureFirewalls@2022-09-01' = {
  name: firewallName
  location: location
  dependsOn: [
    hubVnet
    firewallPip
  ]
  sku: {
    name: 'AZFW_VNet'
    tier: 'Basic'
  }
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          subnet: {
            id: '${hubVnet.id}/subnets/AzureFirewallSubnet'
          }
          publicIPAddress: {
            id: firewallPip.id
          }
        }
      }
    ]
  }
}

// Route Table to send traffic from spokes to Firewall
resource routeTable 'Microsoft.Network/routeTables@2022-09-01' = {
  name: routeTableName
  location: location
  properties: {
    routes: [
      {
        name: 'DefaultRoute'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.0.1.4' // Firewall private IP in subnet, default for Basic SKU
        }
      }
    ]
  }
}

// Output VNet ID and Firewall name
output vnetId string = hubVnet.id
output firewallName string = azureFirewall.name
output firewallPrivateIp string = '10.0.1.4'
