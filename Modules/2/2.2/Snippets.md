# Snippets

```bash
RG=$(az group list --query [].name --output tsv)
ASP_NAME='asp-carvedrockfitness-windows'
ASP_ID=$(az appservice plan show --name $ASP_NAME --resource-group $RG --query id --output tsv)
```

```bash
az monitor autoscale create \
--resource-group $RG \
--resource $ASP_ID \
--min-count 1 \
--max-count 5 \
--count 1
```

```bash
az monitor autoscale rule create \
--autoscale-name 'asp-carvedrockfitness-windows' \
--resource-group $RG  \
--scale out 1 --condition "CPUPercentage > 70 avg 10m"
```

```bash
az monitor autoscale rule create \
--autoscale-name 'asp-carvedrockfitness-windows' \
--resource-group $RG  \
--scale in 1 \
--condition "CPUPercentage < 30 avg 10m"
```
