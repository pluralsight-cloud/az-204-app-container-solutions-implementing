# Snippets

## Setup

```bash
az account set --subscription <Subscription Name>
LOCATION='westus'
RG='rg-configure-web-app-autoscaling'
az group create --location $LOCATION --name $RG
```

## Teardown

```bash
az account set --subscription Sandbox
RG='rg-configure-web-app-autoscaling'
az group delete --name $RG --yes --no-wait
```