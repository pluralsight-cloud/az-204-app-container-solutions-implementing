# Snippets

```bash
git clone https://github.com/WayneHoggett-ACG/CarvedRockFitness.git
```

```bash
cd CarvedRockFitness
code .
RG=$(az group list --query [].name --output tsv)
LOCATION=$(az group list --query [].location --output tsv)
```

```bash
az webapp up --name app-carvedrockfitness-windows --sku B1 --runtime dotnet:8 --plan asp-carvedrockfitness-windows --resource-group $RG --location $LOCATION
```