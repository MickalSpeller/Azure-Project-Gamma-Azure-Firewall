# Secure Hub-and-Spoke Network with Azure Firewall (Azure Project)

This project demonstrates a secure **hub-and-spoke network topology** in Azure with a centrally managed **Azure Firewall** used to inspect and control traffic. It is designed to reinforce key concepts with Azure Firewalls and cloud security.



## Project Overview

- **Hub VNet** hosting Azure Firewall
- **Two Spoke VNets** hosting VMs
- **Peering** between hub and spokes
- **User-Defined Routes (UDRs)** sending all traffic from spokes to the firewall
- **Azure Firewall** for inspecting and controlling egress and ingress
- **Network Security Groups (NSGs)** for subnet-level control



## Architecture Diagram (Logical)
```
                +---------------------------+
                |     Internet / Clients    |
                +-------------+-------------+
                              |
                        [Azure Firewall]
                              |
                     (Hub VNet - 10.0.0.0/16)
                              |
        +---------------------+---------------------+
        |                                           |
 [Spoke VNet1 - 10.1.0.0/16]              [Spoke VNet2 - 10.2.0.0/16]
        |                                           |
      [VM1]                                       [VM2]
```



## Technologies Used

- Azure Bicep (Infrastructure as Code)
- Azure CLI
- Azure Firewall Basic SKU
- B1s VMs for minimal cost



## Folder Structure

```
.
├── main.bicep              # Entry point
├── hubVnet.bicep           # Hub VNet, Firewall, route tables
├── spokeVnet.bicep         # Spoke VNets + subnets + VMs
├── firewallRules.bicep     # Azure Firewall rules
├── variables.bicep         # Common variables and parameters
└── README.md               # Project documentation
```



## Deployment Instructions

```bash
# Login to Azure
az login

# Create resource group
az group create -n rg-hubspoke-fw --location eastus

# Deploy using Bicep
az deployment group create \
  --name hubSpokeDeployment \
  --resource-group rg-hubspoke-fw \
  --template-file main.bicep
```

> NOTE: You can also use GitHub Actions for CI/CD automation of this deployment.



## Outputs
- Public IP of Azure Firewall
- Private IPs of VM1 and VM2
- Confirmed VM traffic must pass through Azure Firewall (SNAT rule)



## Validation Steps

1. SSH into VM1 in Spoke1
2. Curl an external endpoint (e.g., `curl https://microsoft.com`)
3. Check Azure Firewall logs in Diagnostic Settings or Network Watcher



## Cost Notes
- Azure Firewall Basic SKU ≈ $0.39/hr
- B1s VMs ≈ $0.008/hr
- VNets, NSGs, UDRs are free

> Delete resources when finished to avoid cost

```bash
az group delete -n rg-hubspoke-fw --yes --no-wait
```



## AZ-700 Objectives Covered

| Area | Objective |
|------|-----------|
| Design and implement core infrastructure | ✔ Hub-and-spoke topology |
| Secure network connectivity | ✔ Azure Firewall, NSGs |
| Design and implement routing | ✔ UDRs, next hop Firewall |
| Monitor and troubleshoot | ✔ Diagnostic logs for Firewall |



## Acknowledgements

Inspired by real-world Azure architectures for professinal development and proof of concept



## License
MIT - [Full Text](https://opensource.org/licenses/MIT)

---

## Author
Mickal Speller | [Website](https://mickalspeller) | [GitHub](https://github.com/yourgithub)
