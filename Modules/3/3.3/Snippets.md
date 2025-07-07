# Snippets

```bash
RG=$(az group list --query [].name --output tsv)
WINDOWS_APP=$(az webapp list --resource-group $RG --query "[?contains(name,'windows')].{Name:name}" -o tsv)
```

```bash
az webapp log tail \
--name $WINDOWS_APP \
--resource-group $RG \
--provider application
```