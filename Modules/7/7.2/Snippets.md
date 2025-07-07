# Snippets

```bash
RG=$(az group list --query [].name --output tsv)
ACA=$(az containerapp list --query [].name --output tsv)
```

```bash
az containerapp revision list \
--name $ACA \
--resource-group $RG \
--output table
```

```bash
az containerapp revision set-mode \
--name $ACA \
--resource-group $RG \
--mode multiple
```

```bash
az containerapp ingress traffic show \
--resource-group $RG \
--name $ACA \
--output table
```

```bash
CURRENT_REVISION=$(az containerapp revision list --name $ACA --resource-group $RG  --query [].name --output tsv)
az containerapp ingress traffic set --name $ACA --resource-group $RG --revision-weight $CURRENT_REVISION=100
```

```bash
az containerapp update \
--name $ACA \
--resource-group $RG \
--revision-suffix "promotion" \
--set-env-vars PROMOTION="25% off all products for the weekend, use code SAVE25 at checkout."
```

```bash
az containerapp revision list --name $ACA --resource-group $RG --output table
```

```bash
az containerapp revision show --name $ACA --resource-group $RG --revision aca-crf-b2pe74wpstbcw--promotion --query properties.fqdn --output tsv
```

```bash
az containerapp ingress traffic set --name $ACA --resource-group $RG --revision-weight latest=100
```

```bash
az containerapp revision list --name $ACA --resource-group $RG --output table
```

```bash
az containerapp revision deactivate \
--name $ACA \
--resource-group $RG \
--revision "<COPY AND PASTE OLD REVSIION NAME>"
```