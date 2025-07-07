# Snippets

```bash
git clone https://github.com/WayneHoggett-ACG/CarvedRockFitness.git
cd CarvedRockFitness
ls -l
```

```bash
RG=$(az group list --query [].name --output tsv)
LOCATION=$(az group list --query [].location --output tsv)
```

```bash
az containerapp up \
--name carvedrockfitness \
--location $LOCATION \
--resource-group $RG \
--ingress external \
--target-port 8080 \
--source .
```