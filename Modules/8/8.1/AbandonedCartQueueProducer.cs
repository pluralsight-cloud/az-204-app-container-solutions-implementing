using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using Microsoft.Data.SqlClient;
using AbandonedCart.Models;
using Microsoft.IdentityModel.Tokens;

namespace CarvedRockFitness.AbandonedCart;

public class AbandonedCartQueueProducer
{
    private readonly ILogger<AbandonedCartQueueProducer> _logger;

    public AbandonedCartQueueProducer(ILogger<AbandonedCartQueueProducer> logger)
    {
        _logger = logger;
    }

    [Function("AbandonedCartQueueProducer")]
    [QueueOutput("abandoned-carts", Connection = "AzureWebJobsStorage")]
    public IEnumerable<UserCartMessage> Run([TimerTrigger("0 0 5 * * *")] TimerInfo myTimer)
    {
        _logger.LogInformation("C# Timer trigger function executed at: {executionTime}", DateTime.Now);
        var outputMessages = new List<UserCartMessage>();

        string? connectionString = Environment.GetEnvironmentVariable("SqlConnectionString");
        if (connectionString.IsNullOrEmpty())
        {
            _logger.LogError($"'SqlConnectionString' application setting  is required.");
        }
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            try
            {
                conn.Open();
                string query = "SELECT * FROM CartItems";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        var cartItems = new List<CartItem>();
                        while (reader.Read())
                        {
                            cartItems.Add(new CartItem
                            {
                                Id = reader.GetInt32(0),
                                UserId = reader.IsDBNull(1) ? null : reader.GetString(1),
                                ProductId = reader.GetInt32(2),
                                ProductName = reader.GetString(3),
                                Price = reader.GetDecimal(4),
                                Quantity = reader.GetInt32(5),
                                AddedAt = reader.GetDateTime(6)
                            });
                        }

                        foreach (var group in cartItems
                            .Where(c => !string.IsNullOrWhiteSpace(c.UserId))
                            .GroupBy(c => c.UserId!))
                        {
                            outputMessages.Add(new UserCartMessage
                            {
                                UserId = group.Key,
                                Items = group.ToList()
                            });
                            _logger.LogInformation($"Queued cart for user: {group.Key}");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error querying SQL: {ex.Message}");
            }
        }

        if (myTimer.ScheduleStatus is not null)
        {
            _logger.LogInformation("Next timer schedule at: {nextSchedule}", myTimer.ScheduleStatus.Next);
        }

        return outputMessages;
    }
}