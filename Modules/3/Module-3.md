# Module 3: Configuring Azure Web Apps

## Table of Contents

1. [Clip 1: Demo: Configure Azure Web App Service Settings and Connection Strings](#clip-1-demo-configure-azure-web-app-service-settings-and-connection-strings)
2. [Clip 2: Demo: Configure Azure Web App Settings](#clip-2-demo-configure-azure-web-app-settings)
3. [Clip 3: Demo: Enable Diagnostic Logging for Azure Web Apps](#clip-3-demo-enable-diagnostic-logging-for-azure-web-apps)
4. [Clip 4: Demo: Manage Azure Web App Certificates](#clip-4-demo-manage-azure-web-app-certificates)
5. [Clip 5: Demo: Configure Azure Web App Authentication and Authorization](#clip-5-demo-configure-azure-web-app-authentication-and-authorization)

## Clip 1: Demo: Configure Azure Web App Service Settings and Connection Strings

To follow along in this demo using the Cloud Playground Sandbox, follow these steps:

1. Start an [Azure Sandbox](https://app.pluralsight.com/hands-on/playground/cloud-sandboxes).
1. In an InPrivate or Incognito window log in to the Azure Sandbox using the provided credentials.
1. Click the **Deploy to Azure** button. Make sure the link opens in the Sandbox browser tab.

    [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/)

1. Select the existing **Subscription** and **Resource Group**.
1. Deploy the template.
1. Follow-along with the demo.

## Clip 2: Demo: Configure Azure Web App Settings

To follow along in this demo using the Cloud Playground Sandbox, follow these steps:

1. Start an [Azure Sandbox](https://app.pluralsight.com/hands-on/playground/cloud-sandboxes).
1. In an InPrivate or Incognito window log in to the Azure Sandbox using the provided credentials.
1. Click the **Deploy to Azure** button. Make sure the link opens in the Sandbox browser tab.

    [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/)

1. Select the existing **Subscription** and **Resource Group**.
1. Deploy the template.
1. Follow-along with the demo.

## Clip 3: Demo: Enable Diagnostic Logging for Azure Web Apps

To follow along in this demo using the Cloud Playground Sandbox, follow these steps:

1. Start an [Azure Sandbox](https://app.pluralsight.com/hands-on/playground/cloud-sandboxes).
1. In an InPrivate or Incognito window log in to the Azure Sandbox using the provided credentials.
1. Click the **Deploy to Azure** button. Make sure the link opens in the Sandbox browser tab.

    [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/)

1. Select the existing **Subscription** and **Resource Group**.
1. Deploy the template.
1. Follow-along with the demo.

## Clip 4: Demo: Manage Azure Web App Certificates

To follow along in this demo using the Cloud Playground Sandbox, follow these steps:

1. Start an [Azure Sandbox](https://app.pluralsight.com/hands-on/playground/cloud-sandboxes).
1. In an InPrivate or Incognito window log in to the Azure Sandbox using the provided credentials.
1. Click the **Deploy to Azure** button. Make sure the link opens in the Sandbox browser tab.

    [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/)

1. Select the existing **Subscription** and **Resource Group**.
1. Deploy the template.
1. Follow-along with the demo.

## Clip 5: Demo: Configure Azure Web App Authentication and Authorization

1. To follow along with this demonstration you will need your own subscription.
1. Log in to the Azure Portal.
1. Open **Cloud Shell** using **Bash** and set the subscription you'd like to use:

    ```bash
    az account set --subscription "<Subscription ID>"
    ```

    >**Note**: Replace the value of `<Subscription ID>` with the ID of the subscription you'd like to use.

1. Create a resource group for the demonstration.

    > **Note**: You can change the name of the resource group and location as required.

    ```bash
    RG=$(az group create --location <location> --resource-group <resource group name> --query name --output tsv)
    ```

1. Click the **Deploy to Azure** button. Make sure the link opens in the same browser tab as the Azure Portal.

    [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/)

1. Select your preferred **Subscription** and **Resource Group**.
1. Deploy the template.
1. Follow-along with the demo.
