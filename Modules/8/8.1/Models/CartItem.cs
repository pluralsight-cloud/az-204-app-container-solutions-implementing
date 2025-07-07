namespace AbandonedCart.Models
{
    public class CartItem
    {
        public int Id { get; set; }
        public string? UserId { get; set; }
        public int ProductId { get; set; }
        public string ProductName { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public int Quantity { get; set; }
        public DateTime AddedAt { get; set; }
    }
}