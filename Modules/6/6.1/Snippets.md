# Snippets

```bash
RG=$(az group list --query [].name --output tsv)
ACR_NAME=$(az acr list --resource-group $RG --query [].name --output tsv)
ACR_LOGIN_SERVER=$(az acr list --resource-group $RG --query [].loginServer --output tsv)
ACR_LOGIN_USER=$(az acr credential show -n $ACR_NAME --query username --output tsv)
ACR_LOGIN_PASSWORD=$(az acr credential show -n $ACR_NAME --query 'passwords[0].value' --output tsv)
```

```bash
STORAGE_ACCOUNT=$(az storage account list --query [].name --output tsv)
CONN_STRING=$(az storage account show-connection-string --resource-group $RG --name $STORAGE_ACCOUNT --query connectionString --output tsv)
```

```bash
az container create \
--resource-group $RG \
--name crf-wishlist \
--os-type Linux \
--cpu 1 \
--memory 1 \
--image $ACR_LOGIN_SERVER/crfwishlistservice:v1 \
--registry-login-server $ACR_LOGIN_SERVER \
--registry-username $ACR_LOGIN_USER \
--registry-password $ACR_LOGIN_PASSWORD \
--ip-address Public \
--dns-name-label crfwishlist \
--ports 80 \
--restart-policy always \
--secure-environment-variables AzureStorage__ConnectionString=$CONN_STRING \
--query ipAddress.fqdn
```

```bash
az container logs --resource-group $RG --name crf-wishlist --follow
```