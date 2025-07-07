# Snippets

```bash
RG=$(az group list --query [].name --output tsv)
NAME='asp-carvedrockfitness-linux'
```

```bash
az appservice plan create --name $NAME \
--resource-group $RG \
--is-linux \
--sku B1
```
