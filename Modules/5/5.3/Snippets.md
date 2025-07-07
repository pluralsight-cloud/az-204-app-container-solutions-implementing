# Snippets

```bash
git clone https://github.com/WayneHoggett-ACG/CarvedRockFitness
cd CarvedRockFitness/
code Dockerfile
```

```bash
RG=$(az group list --query [].name --output tsv)
ACR=$(az acr list --resource-group $RG --query [].name --output tsv)
```

```bash
az acr import \
--name $ACR \
--source mcr.microsoft.com/dotnet/sdk:8.0 \
--image external/sdk:8.0
```

```bash
az acr import \
--name $ACR \
--source mcr.microsoft.com/dotnet/aspnet:8.0 \
--image external/aspnet:8.0
```

```bash
az acr list --query [].loginServer -o tsv
```

```bash
az acr build --registry $ACR --image internal/crf:v2 .
```

```bash
az acr repository delete --name $ACR --image crf:v1 
```
