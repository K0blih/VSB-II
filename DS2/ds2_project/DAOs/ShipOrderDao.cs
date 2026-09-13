using System.Data;
using Oracle.ManagedDataAccess.Client;

namespace ds2_project.DAOs
{
    public class ShipOrderDao
    {
        private readonly string _connectionString;

        public ShipOrderDao(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("OracleDb")
                ?? throw new InvalidOperationException("Connection string 'OracleDb' is missing.");
        }

        public async Task ShipOrderAsync(int orderId, int warehouseId)
        {
            await using var connection = new OracleConnection(_connectionString);
            await connection.OpenAsync();

            await using var transaction = connection.BeginTransaction(IsolationLevel.ReadCommitted);

            try
            {
                var orderStatus = await GetOrderStatusAsync(connection, transaction, orderId);
                if (orderStatus is null)
                {
                    throw new InvalidOperationException($"Order {orderId} was not found.");
                }

                if (string.Equals(orderStatus, "SHIPPED", StringComparison.OrdinalIgnoreCase))
                {
                    throw new InvalidOperationException($"Order {orderId} has already been shipped.");
                }

                var items = await GetOrderItemsAsync(connection, transaction, orderId);
                if (items.Count == 0)
                {
                    throw new InvalidOperationException($"Order {orderId} has no items to ship.");
                }

                foreach (var item in items)
                {
                    var updatedRows = await UpdateStockAsync(connection, transaction, warehouseId, item.ProductId, item.Quantity);
                    if (updatedRows != 1)
                    {
                        throw new InvalidOperationException(
                            $"Warehouse {warehouseId} does not have enough reserved stock for product {item.ProductId}.");
                    }
                }

                var orderUpdated = await MarkOrderAsShippedAsync(connection, transaction, orderId);
                if (orderUpdated != 1)
                {
                    throw new InvalidOperationException($"Order {orderId} could not be marked as shipped.");
                }

                await transaction.CommitAsync();
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        private static async Task<string?> GetOrderStatusAsync(
            OracleConnection connection,
            OracleTransaction transaction,
            int orderId)
        {
            await using var command = connection.CreateCommand();
            command.Transaction = transaction;
            command.BindByName = true;
            command.CommandText = @"
                SELECT status
                FROM order_header
                WHERE order_id = :order_id";
            command.Parameters.Add("order_id", OracleDbType.Int32).Value = orderId;

            var result = await command.ExecuteScalarAsync();
            return result == null || result == DBNull.Value ? null : Convert.ToString(result);
        }

        private static async Task<List<OrderItemRow>> GetOrderItemsAsync(
            OracleConnection connection,
            OracleTransaction transaction,
            int orderId)
        {
            await using var command = connection.CreateCommand();
            command.Transaction = transaction;
            command.BindByName = true;
            command.CommandText = @"
                SELECT product_id, quantity
                FROM order_item
                WHERE order_id = :order_id";
            command.Parameters.Add("order_id", OracleDbType.Int32).Value = orderId;

            var items = new List<OrderItemRow>();
            await using var reader = await command.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                items.Add(new OrderItemRow(
                    reader.GetInt32(reader.GetOrdinal("product_id")),
                    reader.GetInt32(reader.GetOrdinal("quantity"))));
            }

            return items;
        }

        private static async Task<int> UpdateStockAsync(
            OracleConnection connection,
            OracleTransaction transaction,
            int warehouseId,
            int productId,
            int quantity)
        {
            await using var command = connection.CreateCommand();
            command.Transaction = transaction;
            command.BindByName = true;
            command.CommandText = @"
                UPDATE stock
                SET quantity = quantity - :quantity,
                    reserved_quantity = reserved_quantity - :quantity
                WHERE product_id = :product_id
                  AND warehouse_id = :warehouse_id
                  AND quantity >= :quantity
                  AND reserved_quantity >= :quantity";
            command.Parameters.Add("quantity", OracleDbType.Int32).Value = quantity;
            command.Parameters.Add("product_id", OracleDbType.Int32).Value = productId;
            command.Parameters.Add("warehouse_id", OracleDbType.Int32).Value = warehouseId;

            return await command.ExecuteNonQueryAsync();
        }

        private static async Task<int> MarkOrderAsShippedAsync(
            OracleConnection connection,
            OracleTransaction transaction,
            int orderId)
        {
            await using var command = connection.CreateCommand();
            command.Transaction = transaction;
            command.BindByName = true;
            command.CommandText = @"
                UPDATE order_header
                SET status = 'SHIPPED'
                WHERE order_id = :order_id";
            command.Parameters.Add("order_id", OracleDbType.Int32).Value = orderId;

            return await command.ExecuteNonQueryAsync();
        }

        private record OrderItemRow(int ProductId, int Quantity);
    }
}
