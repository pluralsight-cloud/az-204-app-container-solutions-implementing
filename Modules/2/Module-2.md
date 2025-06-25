# Module 2: Scaling App Service Web Apps

## Table of Contents

1. [Clip 1: Demo: Scale Up an Azure Web App Service Plan](#clip-1-demo-scale-up-an-azure-web-app-service-plan)
2. [Clip 2: Demo: Scale Azure Web Apps using Azure Autoscale](#clip-2-demo-scale-azure-web-apps-using-azure-autoscale)
3. [Clip 3: Demo: Configure Azure Web App Automatic Scaling](#clip-3-demo-deploy-code-to-azure-app-service-automatically)

## Clip 1: Demo: Scale Up an Azure Web App Service Plan

To follow along in this demo using the Cloud Playground Sandbox, follow these steps:

1. Start an [Azure Sandbox](https://app.pluralsight.com/hands-on/playground/cloud-sandboxes).
1. In an InPrivate or Incognito window log in to the Azure Sandbox using the provided credentials.
1. Click the **Deploy to Azure** button. Make sure the link opens in the Sandbox browser tab.

    [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fpluralsight-cloud%2Faz-204-app-container-solutions-implementing%2Frefs%2Fheads%2Fmain%2FModules%2F2%2F2.1%2Fmain.json)

1. Select the existing **Subscription** and **Resource Group**.
1. Provide the `Application Client ID` and `Secret` from the Sandbox details.
1. Deploy the template.
1. Follow-along with the demo.

## Clip 2: Demo: Scale Azure Web Apps using Azure Autoscale

To follow along in this demo using the Cloud Playground Sandbox, follow these steps:

1. Start an [Azure Sandbox](https://app.pluralsight.com/hands-on/playground/cloud-sandboxes).
1. In an InPrivate or Incognito window log in to the Azure Sandbox using the provided credentials.
1. Click the **Deploy to Azure** button. Make sure the link opens in the Sandbox browser tab.

    [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fpluralsight-cloud%2Faz-204-app-container-solutions-implementing%2Frefs%2Fheads%2Fmain%2FModules%2F2%2F2.2%2Fmain.json)

1. Select the existing **Subscription** and **Resource Group**.
1. Provide the `Application Client ID` and `Secret` from the Sandbox details.
1. Deploy the template.
1. Follow-along with the demo.

## Clip 3: Demo: Deploy Code to Azure App Service Automatically

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

    [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fpluralsight-cloud%2Faz-204-app-container-solutions-implementing%2Frefs%2Fheads%2Fmain%2FModules%2F2%2F2.3%2Fmain.json)

1. Select your preferred **Subscription** and **Resource Group**.
1. Deploy the template.
1. Follow-along with the demo.
