# Snippets

```bash
az account show
```

```powershell
$RG=$(az group list --query [].name --output tsv)
$LOCATION=$(az group list --query [].location --output tsv)
```

```powershell
$UNIQUE=(Get-Random)
```

```powershell
$STG_ACCOUNT="stgcrfcart$($UNIQUE)"
az storage account create `
--name $STG_ACCOUNT `
--location $LOCATION `
--resource-group $RG `
--sku Standard_LRS `
--allow-blob-public-access false
```

```powershell
$APP_NAME="AbandonedCart$($UNIQUE)"
az functionapp create `
--name $APP_NAME `
--resource-group $RG `
--consumption-plan-location $LOCATION `
--runtime dotnet-isolated `
--functions-version 4 `
--storage-account $STG_ACCOUNT
```

```powershell
func azure functionapp publish $APP_NAME
```

```powershell
az functionapp config appsettings list --name $APP_NAME --resource-group $RG
```

```powershell
func azure functionapp publish $APP_NAME --publish-settings-only
```

```powershell
az functionapp config appsettings list --name $APP_NAME --resource-group $RG
```
