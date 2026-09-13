namespace ds2_project.DTOs
{
    public class OrderListItemDto
    {
        public int OrderId { get; set; }
        public string CustomerName { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
        public string PaymentStatus { get; set; } = string.Empty;
        public decimal TotalPrice { get; set; }
    }
}
