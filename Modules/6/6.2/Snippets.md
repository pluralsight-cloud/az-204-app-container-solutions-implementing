# Snippets

```bash
RG=$(az group list --query [].name --output tsv)
ACR_NAME=$(az acr list --resource-group $RG --query [].name --output tsv)
ACR_LOGIN_SERVER=$(az acr list --resource-group $RG --query [].loginServer --output tsv)
ACR_LOGIN_USER=$(az acr credential show -n $ACR_NAME --query username --output tsv)
ACR_LOGIN_PASSWORD=$(az acr credential show -n $ACR_NAME --query 'passwords[0].value' --output tsv)
STORAGE_ACCOUNT=$(az storage account list --query [].name --output tsv)
STORAGE_KEY=$(az storage account keys list --resource-group $RG --account-name $STORAGE_ACCOUNT --query [0].value --output tsv)
```

```bash
SHARE_NAME='profilephotos'
az storage share create --name profilephotos --account-name $STORAGE_ACCOUNT
```

```bash
az container create \
--resource-group $RG \
--name crf-profilesvc \
--os-type Linux \
--cpu 1 \
--memory 1 \
--image $ACR_LOGIN_SERVER/crfprofileservice:v1 \
--registry-login-server $ACR_LOGIN_SERVER \
--registry-username $ACR_LOGIN_USER \
--registry-password $ACR_LOGIN_PASSWORD \
--ip-address Public \
--dns-name-label crfprofilesvc \
--ports 8080 \
--restart-policy always \
--azure-file-volume-account-name $STORAGE_ACCOUNT \
--azure-file-volume-account-key $STORAGE_KEY \
--azure-file-volume-share-name $SHARE_NAME \
--azure-file-volume-mount-path /App/profilephotos \
--query ipAddress.fqdn
```

```bash
wget "https://avatars.githubusercontent.com/u/85097958?v=4&size=64" -O wh.jpeg
```

```bash
DOMAIN=$(az container list --resource-group $RG --query [].ipAddress.fqdn --output tsv)
curl -X POST http://$DOMAIN:8080/api/photo/1 -F "file=@wh.jpeg"
```

```bash
curl http://$DOMAIN:8080/api/photo/1 --output downloaded_wh.jpeg
```