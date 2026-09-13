SET DEFINE OFF;

-- TDS I Project - Online Bookstore
-- INSERT SCRIPT for Oracle SQL Developer
-- Version: 12 tables, TDS_ prefix, no INTERVAL datatypes

INSERT INTO tds_person (person_id, first_name, last_name, email, phone, birth_date, profile_photo, person_type)
VALUES (tds_seq_person.NEXTVAL, 'Emma', 'Brown', 'emma.brown@example.com', '+420777111001', DATE '1998-03-14', TO_BLOB(UTL_RAW.CAST_TO_RAW('customer-photo-emma')), 'C');
INSERT INTO tds_customer (customer_id, loyalty_points, registered_at, preferred_contact)
VALUES (tds_seq_person.CURRVAL, 120, DATE '2024-02-10', 'EMAIL');

INSERT INTO tds_person (person_id, first_name, last_name, email, phone, birth_date, profile_photo, person_type)
VALUES (tds_seq_person.NEXTVAL, 'Oliver', 'Smith', 'oliver.smith@example.com', '+420777111002', DATE '1995-07-22', TO_BLOB(UTL_RAW.CAST_TO_RAW('customer-photo-oliver')), 'C');
INSERT INTO tds_customer (customer_id, loyalty_points, registered_at, preferred_contact)
VALUES (tds_seq_person.CURRVAL, 45, DATE '2024-04-18', 'PHONE');

INSERT INTO tds_person (person_id, first_name, last_name, email, phone, birth_date, profile_photo, person_type)
VALUES (tds_seq_person.NEXTVAL, 'Sophia', 'Miller', 'sophia.miller@example.com', '+420777111003', DATE '2001-11-05', TO_BLOB(UTL_RAW.CAST_TO_RAW('customer-photo-sophia')), 'C');
INSERT INTO tds_customer (customer_id, loyalty_points, registered_at, preferred_contact)
VALUES (tds_seq_person.CURRVAL, 300, DATE '2023-12-01', 'EMAIL');

INSERT INTO tds_person (person_id, first_name, last_name, email, phone, birth_date, profile_photo, person_type)
VALUES (tds_seq_person.NEXTVAL, 'Liam', 'Johnson', 'liam.johnson@example.com', '+420777111004', DATE '1989-01-30', TO_BLOB(UTL_RAW.CAST_TO_RAW('customer-photo-liam')), 'C');
INSERT INTO tds_customer (customer_id, loyalty_points, registered_at, preferred_contact)
VALUES (tds_seq_person.CURRVAL, 0, DATE '2025-01-16', 'NONE');

INSERT INTO tds_person (person_id, first_name, last_name, email, phone, birth_date, profile_photo, person_type)
VALUES (tds_seq_person.NEXTVAL, 'Noah', 'Wilson', 'noah.wilson@bookstore.example.com', '+420777222001', DATE '1982-09-12', TO_BLOB(UTL_RAW.CAST_TO_RAW('employee-photo-noah')), 'E');
INSERT INTO tds_employee (employee_id, job_title, hire_date, salary, employment_status)
VALUES (tds_seq_person.CURRVAL, 'Store Manager', DATE '2021-06-01', 58000, 'ACTIVE');

INSERT INTO tds_person (person_id, first_name, last_name, email, phone, birth_date, profile_photo, person_type)
VALUES (tds_seq_person.NEXTVAL, 'Ava', 'Davis', 'ava.davis@bookstore.example.com', '+420777222002', DATE '1990-05-17', TO_BLOB(UTL_RAW.CAST_TO_RAW('employee-photo-ava')), 'E');
INSERT INTO tds_employee (employee_id, job_title, hire_date, salary, employment_status)
VALUES (tds_seq_person.CURRVAL, 'Sales Specialist', DATE '2022-03-15', 36500, 'ACTIVE');

INSERT INTO tds_person (person_id, first_name, last_name, email, phone, birth_date, profile_photo, person_type)
VALUES (tds_seq_person.NEXTVAL, 'Mia', 'Taylor', 'mia.taylor@bookstore.example.com', '+420777222003', DATE '1993-12-08', TO_BLOB(UTL_RAW.CAST_TO_RAW('employee-photo-mia')), 'E');
INSERT INTO tds_employee (employee_id, job_title, hire_date, salary, employment_status)
VALUES (tds_seq_person.CURRVAL, 'Warehouse Coordinator', DATE '2022-09-01', 39000, 'ACTIVE');

INSERT INTO tds_employee_salary_history VALUES (5, DATE '2021-06-01', DATE '2023-12-31', NULL, 52000, 'Initial salary', SYSTIMESTAMP);
INSERT INTO tds_employee_salary_history VALUES (5, DATE '2024-01-01', NULL, 52000, 58000, 'Annual increase', SYSTIMESTAMP);
INSERT INTO tds_employee_salary_history VALUES (6, DATE '2022-03-15', DATE '2024-03-31', NULL, 33000, 'Initial salary', SYSTIMESTAMP);
INSERT INTO tds_employee_salary_history VALUES (6, DATE '2024-04-01', NULL, 33000, 36500, 'Performance increase', SYSTIMESTAMP);
INSERT INTO tds_employee_salary_history VALUES (7, DATE '2022-09-01', NULL, NULL, 39000, 'Initial salary', SYSTIMESTAMP);

INSERT INTO tds_publisher VALUES (tds_seq_publisher.NEXTVAL, 'Northern Star Press', 'CZ', 'https://northernstar.example.com', SYSTIMESTAMP);
INSERT INTO tds_publisher VALUES (tds_seq_publisher.NEXTVAL, 'River House Books', 'US', 'https://riverhouse.example.com', SYSTIMESTAMP);
INSERT INTO tds_publisher VALUES (tds_seq_publisher.NEXTVAL, 'Blue Oak Publishing', 'GB', 'https://blueoak.example.com', SYSTIMESTAMP);

INSERT INTO tds_author VALUES (tds_seq_author.NEXTVAL, 'Arthur', 'Clark', 'Author of science and technology books.', DATE '1975-02-18', 'British');
INSERT INTO tds_author VALUES (tds_seq_author.NEXTVAL, 'Elena', 'Novak', 'Writes modern European fiction and essays.', DATE '1981-08-09', 'Czech');
INSERT INTO tds_author VALUES (tds_seq_author.NEXTVAL, 'James', 'Walker', 'Specialist in business and analytics books.', DATE '1969-04-27', 'American');
INSERT INTO tds_author VALUES (tds_seq_author.NEXTVAL, 'Clara', 'Stone', 'Children literature writer.', DATE '1988-10-03', 'Canadian');
INSERT INTO tds_author VALUES (tds_seq_author.NEXTVAL, 'Daniel', 'Green', 'Historian focused on Central Europe.', DATE '1972-06-20', 'Irish');

INSERT INTO tds_category VALUES (tds_seq_category.NEXTVAL, NULL, 'Books', 'Y');
INSERT INTO tds_category VALUES (tds_seq_category.NEXTVAL, 1, 'Fiction', 'Y');
INSERT INTO tds_category VALUES (tds_seq_category.NEXTVAL, 1, 'Non-fiction', 'Y');
INSERT INTO tds_category VALUES (tds_seq_category.NEXTVAL, 2, 'Science Fiction', 'Y');
INSERT INTO tds_category VALUES (tds_seq_category.NEXTVAL, 2, 'Children', 'Y');
INSERT INTO tds_category VALUES (tds_seq_category.NEXTVAL, 3, 'Business', 'Y');
INSERT INTO tds_category VALUES (tds_seq_category.NEXTVAL, 3, 'History', 'Y');

INSERT INTO tds_book VALUES (tds_seq_book.NEXTVAL, 1, 4, '978-80-000001-1', 'Orbit of Tomorrow', DATE '2021-05-20', 320, 399.90, 10, TO_BLOB(UTL_RAW.CAST_TO_RAW('sample-ebook-orbit')), 'A science fiction novel about an orbital city.', 510, TIMESTAMP '2023-05-20 09:00:00', SYSTIMESTAMP);
INSERT INTO tds_book VALUES (tds_seq_book.NEXTVAL, 1, 6, '978-80-000002-8', 'Data Driven Shop', DATE '2022-09-12', 260, 549.00, 10, TO_BLOB(UTL_RAW.CAST_TO_RAW('sample-ebook-data')), 'Practical analytics for retail managers.', 375, TIMESTAMP '2024-03-12 09:00:00', SYSTIMESTAMP);
INSERT INTO tds_book VALUES (tds_seq_book.NEXTVAL, 2, 2, '978-80-000003-5', 'Winter Letters', DATE '2019-11-03', 210, 299.00, 10, TO_BLOB(UTL_RAW.CAST_TO_RAW('sample-ebook-winter')), 'A novel told through letters.', 300, TIMESTAMP '2022-11-03 09:00:00', SYSTIMESTAMP);
INSERT INTO tds_book VALUES (tds_seq_book.NEXTVAL, 3, 5, '978-80-000004-2', 'The Little Compass', DATE '2020-03-25', 96, 189.50, 10, TO_BLOB(UTL_RAW.CAST_TO_RAW('sample-ebook-compass')), 'Adventure story for children.', 105, TIMESTAMP '2022-03-25 09:00:00', SYSTIMESTAMP);
INSERT INTO tds_book VALUES (tds_seq_book.NEXTVAL, 3, 7, '978-80-000005-9', 'Markets of Prague', DATE '2018-06-14', 380, 459.90, 10, TO_BLOB(UTL_RAW.CAST_TO_RAW('sample-ebook-prague')), 'History of markets and trade in Prague.', 560, TIMESTAMP '2023-06-14 09:00:00', SYSTIMESTAMP);
INSERT INTO tds_book VALUES (tds_seq_book.NEXTVAL, 2, 6, '978-80-000006-6', 'Clean Inventory', DATE '2023-01-09', 180, 349.00, 10, TO_BLOB(UTL_RAW.CAST_TO_RAW('sample-ebook-inventory')), 'Inventory management for small companies.', 280, TIMESTAMP '2024-01-09 09:00:00', SYSTIMESTAMP);

INSERT INTO tds_book_author VALUES (1, 1);
INSERT INTO tds_book_author VALUES (2, 3);
INSERT INTO tds_book_author VALUES (3, 2);
INSERT INTO tds_book_author VALUES (4, 4);
INSERT INTO tds_book_author VALUES (5, 5);
INSERT INTO tds_book_author VALUES (6, 3);
INSERT INTO tds_book_author VALUES (6, 5);

INSERT INTO tds_customer_order VALUES (tds_seq_order.NEXTVAL, 1, 6, DATE '2026-04-10', 'DELIVERED', 'Vinohradska 10, Prague', 'Leave at reception.', 948.90);
INSERT INTO tds_order_item VALUES (tds_seq_order.CURRVAL, 1, 1, 1, 399.90, 0);
INSERT INTO tds_order_item VALUES (tds_seq_order.CURRVAL, 2, 2, 1, 549.00, 0);

INSERT INTO tds_customer_order VALUES (tds_seq_order.NEXTVAL, 2, 6, DATE '2026-04-18', 'SHIPPED', 'Kounicova 22, Brno', NULL, 488.50);
INSERT INTO tds_order_item VALUES (tds_seq_order.CURRVAL, 1, 3, 1, 299.00, 0);
INSERT INTO tds_order_item VALUES (tds_seq_order.CURRVAL, 2, 4, 1, 189.50, 0);

INSERT INTO tds_customer_order VALUES (tds_seq_order.NEXTVAL, 3, 7, DATE '2026-05-02', 'PAID', 'Masarykova 5, Ostrava', 'Call before delivery.', 809.90);
INSERT INTO tds_order_item VALUES (tds_seq_order.CURRVAL, 1, 5, 1, 459.90, 0);
INSERT INTO tds_order_item VALUES (tds_seq_order.CURRVAL, 2, 6, 1, 349.00, 0);

INSERT INTO tds_customer_order VALUES (tds_seq_order.NEXTVAL, 4, NULL, DATE '2026-05-06', 'NEW', 'Dlouha 7, Prague', NULL, 379.00);
INSERT INTO tds_order_item VALUES (tds_seq_order.CURRVAL, 1, 4, 2, 189.50, 0);

INSERT INTO tds_payment VALUES (tds_seq_payment.NEXTVAL, 1, TIMESTAMP '2026-04-10 10:30:00', 948.90, 'CARD', 'CARD-TRX-10001', NULL, NULL);
INSERT INTO tds_payment VALUES (tds_seq_payment.NEXTVAL, 2, TIMESTAMP '2026-04-18 14:05:00', 488.50, 'BANK_TRANSFER', NULL, 'BANK-20260418-778', NULL);
INSERT INTO tds_payment VALUES (tds_seq_payment.NEXTVAL, 3, TIMESTAMP '2026-05-02 09:44:00', 809.90, 'GIFT_CARD', NULL, NULL, 'GIFT-MAY-2026-15');

COMMIT;
