SET SERVEROUTPUT ON;

BEGIN
    -- Repeatable seed cleanup.
    DELETE FROM payment WHERE order_id BETWEEN 1 AND 99;
    DELETE FROM order_item WHERE order_id BETWEEN 1 AND 99;
    DELETE FROM order_header WHERE order_id BETWEEN 1 AND 99;
    DELETE FROM stock WHERE stock_id BETWEEN 1 AND 99;
    DELETE FROM product WHERE product_id BETWEEN 1 AND 99;
    DELETE FROM category WHERE category_id BETWEEN 2 AND 99;
    DELETE FROM category WHERE category_id = 1;
    DELETE FROM warehouse WHERE warehouse_id BETWEEN 1 AND 99;
    DELETE FROM address WHERE address_id BETWEEN 1 AND 99;
    DELETE FROM customer WHERE customer_id BETWEEN 1 AND 99;

    -- Customers
    INSERT INTO customer(customer_id, first_name, last_name, email, phone, birth_date)
    VALUES (1, 'Anna', 'Novakova', 'anna.novakova@example.com', '+420600100001', DATE '1999-04-12');

    INSERT INTO customer(customer_id, first_name, last_name, email, phone, birth_date)
    VALUES (2, 'Petr', 'Svoboda', 'petr.svoboda@example.com', '+420600100002', DATE '1998-08-21');

    INSERT INTO customer(customer_id, first_name, last_name, email, phone, birth_date)
    VALUES (3, 'Lucie', 'Dvorakova', 'lucie.dvorakova@example.com', '+420600100003', DATE '2001-01-30');

    INSERT INTO customer(customer_id, first_name, last_name, email, phone, birth_date)
    VALUES (4, 'Tomas', 'Cerny', 'tomas.cerny@example.com', '+420600100004', DATE '1997-11-05');

    INSERT INTO customer(customer_id, first_name, last_name, email, phone, birth_date)
    VALUES (5, 'Eva', 'Kralova', 'eva.kralova@example.com', '+420600100005', DATE '2000-06-18');

    -- Addresses
    INSERT INTO address(address_id, customer_id, street, city, zip_code, country, type)
    VALUES (1, 1, 'Hlavni 12', 'Ostrava', '70200', 'Czech Republic', 'shipping');

    INSERT INTO address(address_id, customer_id, street, city, zip_code, country, type)
    VALUES (2, 1, 'Hlavni 12', 'Ostrava', '70200', 'Czech Republic', 'billing');

    INSERT INTO address(address_id, customer_id, street, city, zip_code, country, type)
    VALUES (3, 2, 'Studentska 45', 'Ostrava', '70800', 'Czech Republic', 'shipping');

    INSERT INTO address(address_id, customer_id, street, city, zip_code, country, type)
    VALUES (4, 2, 'Studentska 45', 'Ostrava', '70800', 'Czech Republic', 'billing');

    INSERT INTO address(address_id, customer_id, street, city, zip_code, country, type)
    VALUES (5, 3, 'Masarykova 9', 'Brno', '60200', 'Czech Republic', 'shipping');

    INSERT INTO address(address_id, customer_id, street, city, zip_code, country, type)
    VALUES (6, 3, 'Masarykova 9', 'Brno', '60200', 'Czech Republic', 'billing');

    INSERT INTO address(address_id, customer_id, street, city, zip_code, country, type)
    VALUES (7, 4, 'Dlouha 18', 'Praha', '11000', 'Czech Republic', 'shipping');

    INSERT INTO address(address_id, customer_id, street, city, zip_code, country, type)
    VALUES (8, 4, 'Dlouha 18', 'Praha', '11000', 'Czech Republic', 'billing');

    INSERT INTO address(address_id, customer_id, street, city, zip_code, country, type)
    VALUES (9, 5, 'Nadrazni 22', 'Olomouc', '77900', 'Czech Republic', 'shipping');

    INSERT INTO address(address_id, customer_id, street, city, zip_code, country, type)
    VALUES (10, 5, 'Nadrazni 22', 'Olomouc', '77900', 'Czech Republic', 'billing');

    -- Categories
    INSERT INTO category(category_id, name, parent_category_id)
    VALUES (1, 'E-shop Products', NULL);

    INSERT INTO category(category_id, name, parent_category_id)
    VALUES (2, 'Peripherals', 1);

    INSERT INTO category(category_id, name, parent_category_id)
    VALUES (3, 'Office', 1);

    INSERT INTO category(category_id, name, parent_category_id)
    VALUES (4, 'Accessories', 1);

    INSERT INTO category(category_id, name, parent_category_id)
    VALUES (5, 'Storage', 1);

    -- Products
    INSERT INTO product(product_id, category_id, name, description, price, vat, is_active)
    VALUES (1, 2, 'Mechanical Keyboard', 'Compact mechanical keyboard with blue switches.', 89.90, 21, 'Y');

    INSERT INTO product(product_id, category_id, name, description, price, vat, is_active)
    VALUES (2, 2, 'Wireless Mouse', 'Ergonomic wireless mouse.', 34.50, 21, 'Y');

    INSERT INTO product(product_id, category_id, name, description, price, vat, is_active)
    VALUES (3, 2, 'USB-C Dock', 'Multiport dock for notebook users.', 129.50, 21, 'Y');

    INSERT INTO product(product_id, category_id, name, description, price, vat, is_active)
    VALUES (4, 3, 'Monitor Arm', 'Adjustable desk monitor arm.', 59.90, 21, 'Y');

    INSERT INTO product(product_id, category_id, name, description, price, vat, is_active)
    VALUES (5, 4, 'Laptop Sleeve', 'Protective sleeve for 14 inch laptop.', 24.90, 21, 'Y');

    INSERT INTO product(product_id, category_id, name, description, price, vat, is_active)
    VALUES (6, 5, 'External SSD 1TB', 'Portable USB-C solid state drive.', 109.90, 21, 'Y');

    INSERT INTO product(product_id, category_id, name, description, price, vat, is_active)
    VALUES (7, 4, 'HDMI Cable', 'Two meter HDMI cable.', 9.90, 21, 'Y');

    INSERT INTO product(product_id, category_id, name, description, price, vat, is_active)
    VALUES (8, 3, 'Desk Lamp', 'LED desk lamp with dimmer.', 39.90, 21, 'Y');

    -- Warehouses
    INSERT INTO warehouse(warehouse_id, name, city)
    VALUES (1, 'Main Warehouse Ostrava', 'Ostrava');

    INSERT INTO warehouse(warehouse_id, name, city)
    VALUES (2, 'Backup Warehouse Brno', 'Brno');

    INSERT INTO warehouse(warehouse_id, name, city)
    VALUES (3, 'Express Warehouse Praha', 'Praha');

    -- Stock
    INSERT INTO stock(stock_id, product_id, warehouse_id, quantity, reserved_quantity)
    VALUES (1, 1, 1, 50, 5);

    INSERT INTO stock(stock_id, product_id, warehouse_id, quantity, reserved_quantity)
    VALUES (2, 2, 1, 80, 8);

    INSERT INTO stock(stock_id, product_id, warehouse_id, quantity, reserved_quantity)
    VALUES (3, 3, 1, 35, 3);

    INSERT INTO stock(stock_id, product_id, warehouse_id, quantity, reserved_quantity)
    VALUES (4, 4, 1, 25, 2);

    INSERT INTO stock(stock_id, product_id, warehouse_id, quantity, reserved_quantity)
    VALUES (5, 5, 1, 60, 4);

    INSERT INTO stock(stock_id, product_id, warehouse_id, quantity, reserved_quantity)
    VALUES (6, 6, 1, 30, 2);

    INSERT INTO stock(stock_id, product_id, warehouse_id, quantity, reserved_quantity)
    VALUES (7, 7, 1, 120, 10);

    INSERT INTO stock(stock_id, product_id, warehouse_id, quantity, reserved_quantity)
    VALUES (8, 8, 1, 40, 3);

    INSERT INTO stock(stock_id, product_id, warehouse_id, quantity, reserved_quantity)
    VALUES (9, 1, 2, 20, 0);

    INSERT INTO stock(stock_id, product_id, warehouse_id, quantity, reserved_quantity)
    VALUES (10, 3, 2, 15, 0);

    INSERT INTO stock(stock_id, product_id, warehouse_id, quantity, reserved_quantity)
    VALUES (11, 6, 2, 12, 0);

    INSERT INTO stock(stock_id, product_id, warehouse_id, quantity, reserved_quantity)
    VALUES (12, 2, 3, 25, 0);

    INSERT INTO stock(stock_id, product_id, warehouse_id, quantity, reserved_quantity)
    VALUES (13, 5, 3, 35, 0);

    INSERT INTO stock(stock_id, product_id, warehouse_id, quantity, reserved_quantity)
    VALUES (14, 7, 3, 70, 0);

    -- READY + PAID orders for ship_order testing.
    INSERT INTO order_header(order_id, customer_id, order_date, status, payment_status, shipping_address_id, billing_address_id, total_price)
    VALUES (1, 1, SYSDATE - 3, 'READY', 'PAID', 1, 2, 214.30);

    INSERT INTO order_item(order_id, product_id, quantity, unit_price, discount_percent)
    VALUES (1, 1, 1, 89.90, 0);

    INSERT INTO order_item(order_id, product_id, quantity, unit_price, discount_percent)
    VALUES (1, 3, 1, 129.50, 4);

    INSERT INTO payment(order_id, amount, payment_method, status)
    VALUES (1, 214.30, 'CARD', 'PAID');

    INSERT INTO order_header(order_id, customer_id, order_date, status, payment_status, shipping_address_id, billing_address_id, total_price)
    VALUES (2, 2, SYSDATE - 2, 'READY', 'PAID', 3, 4, 128.90);

    INSERT INTO order_item(order_id, product_id, quantity, unit_price, discount_percent)
    VALUES (2, 2, 2, 34.50, 0);

    INSERT INTO order_item(order_id, product_id, quantity, unit_price, discount_percent)
    VALUES (2, 5, 2, 24.90, 0);

    INSERT INTO order_item(order_id, product_id, quantity, unit_price, discount_percent)
    VALUES (2, 7, 1, 9.90, 0);

    INSERT INTO payment(order_id, amount, payment_method, status)
    VALUES (2, 128.90, 'CARD', 'PAID');

    INSERT INTO order_header(order_id, customer_id, order_date, status, payment_status, shipping_address_id, billing_address_id, total_price)
    VALUES (3, 3, SYSDATE - 1, 'READY', 'PAID', 5, 6, 219.80);

    INSERT INTO order_item(order_id, product_id, quantity, unit_price, discount_percent)
    VALUES (3, 6, 2, 109.90, 0);

    INSERT INTO payment(order_id, amount, payment_method, status)
    VALUES (3, 219.80, 'BANK_TRANSFER', 'PAID');

    -- Extra non-shipping states.
    INSERT INTO order_header(order_id, customer_id, order_date, status, payment_status, shipping_address_id, billing_address_id, total_price)
    VALUES (4, 4, SYSDATE - 5, 'CREATED', 'UNPAID', 7, 8, 99.80);

    INSERT INTO order_item(order_id, product_id, quantity, unit_price, discount_percent)
    VALUES (4, 4, 1, 59.90, 0);

    INSERT INTO order_item(order_id, product_id, quantity, unit_price, discount_percent)
    VALUES (4, 8, 1, 39.90, 0);

    INSERT INTO order_header(order_id, customer_id, order_date, status, payment_status, shipping_address_id, billing_address_id, total_price)
    VALUES (5, 5, SYSDATE - 7, 'SHIPPED', 'PAID', 9, 10, 44.40);

    INSERT INTO order_item(order_id, product_id, quantity, unit_price, discount_percent)
    VALUES (5, 5, 1, 24.90, 0);

    INSERT INTO order_item(order_id, product_id, quantity, unit_price, discount_percent)
    VALUES (5, 7, 2, 9.90, 0);

    INSERT INTO payment(order_id, amount, payment_method, status)
    VALUES (5, 44.40, 'CARD', 'PAID');

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Seed data inserted successfully.');
    DBMS_OUTPUT.PUT_LINE('Use these in the Ship Order form with Warehouse ID 1:');
    DBMS_OUTPUT.PUT_LINE('Order ID 1, Warehouse ID 1');
    DBMS_OUTPUT.PUT_LINE('Order ID 2, Warehouse ID 1');
    DBMS_OUTPUT.PUT_LINE('Order ID 3, Warehouse ID 1');
END;
/
