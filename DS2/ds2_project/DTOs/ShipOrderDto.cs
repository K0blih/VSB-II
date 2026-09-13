using System.ComponentModel.DataAnnotations;

namespace ds2_project.DTOs
{
    public class ShipOrderDto
    {
        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "Order ID must be a positive number.")]
        [Display(Name = "Order ID")]
        public int? OrderId { get; set; }

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "Warehouse ID must be a positive number.")]
        [Display(Name = "Warehouse ID")]
        public int? WarehouseId { get; set; }
    }
}
