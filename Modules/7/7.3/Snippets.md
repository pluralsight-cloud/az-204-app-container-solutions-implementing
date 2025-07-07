# Snippets

```bash
RG=$(az group list --query [].name --output tsv)
ACA=$(az containerapp list --query [].name --output tsv)
```

```bash
SQL_SERVER=$(az sql server list --resource-group $RG --query [].name --output tsv)
SQL_DB='carvedrockfitnessdb'
az sql db show-connection-string --server $SQL_SERVER --name $SQL_DB --client ado.net
```

```bash
az containerapp secret set \
--name $ACA \
--resource-group $RG \
--secrets default-connection="<COPY AND PASTE STRING>"
```

```bash
--secrets "default-connection="=keyvaultref:<KEY_VAULT_SECRET_URI>,identityref:<USER_ASSIGNED_IDENTITY_ID>"
```

```bash
az containerapp update \
--name $ACA \
--resource-group $RG \
--set-env-vars DefaultConnection=secretref:default-connection \
--query properties.configuration.ingress.fqdn
```

```bash
--secret-volume-mount "/mnt/secrets"
```