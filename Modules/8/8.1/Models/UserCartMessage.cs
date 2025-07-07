namespace AbandonedCart.Models
{
    public class UserCartMessage
    {
        public string UserId { get; set; } = string.Empty;
        public List<CartItem> Items { get; set; } = new();
    }
}