# Snippets

```bash
git clone https://github.com/WayneHoggett-ACG/CarvedRockFitness
cd CarvedRockFitness/
```

```bash
RG=$(az group list --query [].name --output tsv)
ACR=$(az acr list --resource-group $RG --query [].name --output tsv)
az acr build --registry $ACR --image crf:v1 .
```

```bash
az acr task create \
--registry $ACR \
--name buildcrf \
--image crf:{{.Run.ID}} \
--context https://github.com/WayneHoggett-ACG/CarvedRockFitness#main \
--file Dockerfile \
--git-access-token <PAT>
```