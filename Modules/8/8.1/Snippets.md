# Snippets

- [`Models/CartItem.cs`](../8.1/Models/CartItem.cs)
- [`UserCartMessage.cs`](../8.1/Models/UserCartMessage.cs)
- [`AbandonedCartQueueProducer.cs`](../8.1/AbandonedCartQueueProducer.cs)

```bash
dotnet add package Microsoft.Data.SqlClient
```

```bash
dotnet add package Microsoft.Azure.Functions.Worker.Extensions.Storage.Queues
```

`localsettings.json`

```json
"AzureWebJobsStorage": "UseDevelopmentStorage=true",
"SqlConnectionString": "<Connection String>"
```
