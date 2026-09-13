namespace ds2_project.DTOs
{
    public class StockListItemDto
    {
        public int WarehouseId { get; set; }
        public string ProductName { get; set; } = string.Empty;
        public int Quantity { get; set; }
        public int ReservedQuantity { get; set; }
    }
}
