namespace ds2_project.DTOs
{
    public class ProductListItemDto
    {
        public int ProductId { get; set; }
        public string Name { get; set; } = string.Empty;
        public string CategoryName { get; set; } = string.Empty;
        public decimal Price { get; set; }
        public decimal Vat { get; set; }
    }
}
