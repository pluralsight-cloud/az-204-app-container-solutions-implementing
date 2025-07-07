# Snippets

```bash
RG=$(az group list --query [].name --output tsv)
az appservice plan update \
--name 'asp-carvedrockfitness-linux' \
--resource-group $RG \
--sku S1
```