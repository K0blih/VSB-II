using ds2_project.DTOs;
using Oracle.ManagedDataAccess.Client;

namespace ds2_project.DAOs
{
    public class ShopDao
    {
        private readonly string _connectionString;

        public ShopDao(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("OracleDb")
                ?? throw new InvalidOperationException("Connection string 'OracleDb' is missing.");
        }

        public async Task<List<ProductListItemDto>> GetProductsAsync()
        {
            await using var connection = new OracleConnection(_connectionString);
            await using var command = connection.CreateCommand();
            command.CommandText = @"
                SELECT p.product_id,
                       p.name,
                       c.name AS category_name,
                       p.price,
                       p.vat
                FROM product p
                JOIN category c ON c.category_id = p.category_id
                ORDER BY p.product_id";

            await connection.OpenAsync();
            await using var reader = await command.ExecuteReaderAsync();

            var products = new List<ProductListItemDto>();
            while (await reader.ReadAsync())
            {
                products.Add(new ProductListItemDto
                {
                    ProductId = reader.GetInt32(reader.GetOrdinal("product_id")),
                    Name = reader.GetString(reader.GetOrdinal("name")),
                    CategoryName = reader.GetString(reader.GetOrdinal("category_name")),
                    Price = reader.GetDecimal(reader.GetOrdinal("price")),
                    Vat = reader.GetDecimal(reader.GetOrdinal("vat"))
                });
            }

            return products;
        }

        public async Task<List<OrderListItemDto>> GetOrdersAsync()
        {
            await using var connection = new OracleConnection(_connectionString);
            await using var command = connection.CreateCommand();
            command.CommandText = @"
                SELECT oh.order_id,
                       c.first_name || ' ' || c.last_name AS customer_name,
                       oh.status,
                       oh.payment_status,
                       oh.total_price
                FROM order_header oh
                JOIN customer c ON c.customer_id = oh.customer_id
                ORDER BY oh.order_id";

            await connection.OpenAsync();
            await using var reader = await command.ExecuteReaderAsync();

            var orders = new List<OrderListItemDto>();
            while (await reader.ReadAsync())
            {
                orders.Add(new OrderListItemDto
                {
                    OrderId = reader.GetInt32(reader.GetOrdinal("order_id")),
                    CustomerName = reader.GetString(reader.GetOrdinal("customer_name")),
                    Status = reader.GetString(reader.GetOrdinal("status")),
                    PaymentStatus = reader.GetString(reader.GetOrdinal("payment_status")),
                    TotalPrice = reader.GetDecimal(reader.GetOrdinal("total_price"))
                });
            }

            return orders;
        }

        public async Task<List<WarehouseDto>> GetWarehousesAsync()
        {
            await using var connection = new OracleConnection(_connectionString);
            await using var command = connection.CreateCommand();
            command.CommandText = @"
                SELECT warehouse_id, name, city
                FROM warehouse
                ORDER BY warehouse_id";

            await connection.OpenAsync();
            await using var reader = await command.ExecuteReaderAsync();

            var warehouses = new List<WarehouseDto>();
            while (await reader.ReadAsync())
            {
                warehouses.Add(new WarehouseDto
                {
                    WarehouseId = reader.GetInt32(reader.GetOrdinal("warehouse_id")),
                    Name = reader.GetString(reader.GetOrdinal("name")),
                    City = reader.GetString(reader.GetOrdinal("city"))
                });
            }

            return warehouses;
        }

        public async Task<List<StockListItemDto>> GetStockAsync()
        {
            await using var connection = new OracleConnection(_connectionString);
            await using var command = connection.CreateCommand();
            command.CommandText = @"
                SELECT s.warehouse_id,
                       p.name AS product_name,
                       s.quantity,
                       s.reserved_quantity
                FROM stock s
                JOIN product p ON p.product_id = s.product_id
                ORDER BY s.warehouse_id, s.product_id";

            await connection.OpenAsync();
            await using var reader = await command.ExecuteReaderAsync();

            var stock = new List<StockListItemDto>();
            while (await reader.ReadAsync())
            {
                stock.Add(new StockListItemDto
                {
                    WarehouseId = reader.GetInt32(reader.GetOrdinal("warehouse_id")),
                    ProductName = reader.GetString(reader.GetOrdinal("product_name")),
                    Quantity = reader.GetInt32(reader.GetOrdinal("quantity")),
                    ReservedQuantity = reader.GetInt32(reader.GetOrdinal("reserved_quantity"))
                });
            }

            return stock;
        }
    }
}
