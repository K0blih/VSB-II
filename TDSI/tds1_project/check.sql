SET SERVEROUTPUT ON;

PROMPT =========================
PROMPT Ship Order Change Summary
PROMPT =========================

SELECT
    oh.order_id,
    oh.status AS order_status,
    oi.product_id,
    oi.quantity AS ordered_quantity,
    s.warehouse_id,
    s.quantity AS current_stock_quantity,
    s.reserved_quantity AS current_reserved_quantity,
    s.quantity - s.reserved_quantity AS available_quantity
FROM order_header oh
JOIN order_item oi ON oi.order_id = oh.order_id
JOIN product p ON p.product_id = oi.product_id
JOIN stock s ON s.product_id = oi.product_id
WHERE oh.order_id BETWEEN 1 AND 3
  AND s.warehouse_id = 1
ORDER BY oh.order_id, oi.product_id;
