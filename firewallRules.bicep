// firewallRules.bicep
param location string
param firewallName string

resource azureFirewall 'Microsoft.Network/azureFirewalls@2022-09-01' existing = {
  name: firewallName
  scope: resourceGroup()
}

resource appRuleCollection 'Microsoft.Network/azureFirewalls/applicationRuleCollections@2022-09-01' = {
  name: '${firewallName}/AppRuleCollection1'
  properties: {
    priority: 100
    action: {
      type: 'Allow'
    }
    rules: [
      {
        name: 'Allow-Web-Microsoft'
        description: 'Allow web traffic to microsoft.com'
        protocols: [
          {
            protocolType: 'Http'
            port: 80
          }
          {
            protocolType: 'Https'
            port: 443
          }
        ]
        sourceAddresses: [
          '10.1.0.0/16'
          '10.2.0.0/16'
        ]
        targetFqdns: [
          'microsoft.com'
          'www.microsoft.com'
        ]
      }
    ]
  }
}

resource networkRuleCollection 'Microsoft.Network/azureFirewalls/networkRuleCollections@2022-09-01' = {
  name: '${firewallName}/NetRuleCollection1'
  properties: {
    priority: 200
    action: {
      type: 'Allow'
    }
    rules: [
      {
        name: 'Allow-DNS'
        protocol: 'UDP'
        sourceAddresses: [
          '10.1.0.0/16'
          '10.2.0.0/16'
        ]
        destinationPorts: [
          '53'
        ]
        destinationAddresses: [
          '8.8.8.8'
          '8.8.4.4'
        ]
      }
    ]
  }
}
