namespace ds2_project.DTOs
{
    public class WarehousePageDto
    {
        public List<WarehouseDto> Warehouses { get; set; } = [];
        public List<StockListItemDto> Stock { get; set; } = [];
    }
}
