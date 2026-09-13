SET SERVEROUTPUT ON;
SET DEFINE OFF;
ALTER SESSION SET recyclebin = ON;

PROMPT TDS I PROJECT - RUNNABLE SQL EXAMPLES FOR ONLINE BOOKSTORE
ALTER SESSION SET NLS_DATE_LANGUAGE = 'ENGLISH';

PROMPT Cleanup demo objects
BEGIN
  FOR v IN (SELECT view_name FROM user_views WHERE view_name IN (
    'TDS_V_BOOK_PRICES','TDS_V_ORDER_TOTALS','TDS_V_READONLY_BOOKS','TDS_V_FORCE_DEMO','TDS_V_NOFORCE_DEMO','TDS_V_GRANT_DEMO')) LOOP
    EXECUTE IMMEDIATE 'DROP VIEW ' || v.view_name;
  END LOOP;
END;
/
BEGIN
  FOR t IN (SELECT table_name FROM user_tables WHERE table_name IN (
    'TDS_DEMO_EXPENSIVE_BOOKS','TDS_DEMO_PEOPLE','TDS_DEMO_A','TDS_DEMO_B','TDS_DEMO_STOCK',
    'TDS_DEMO_ALTER','TDS_DEMO_RENAME_OLD','TDS_DEMO_RENAME_NEW','TDS_DEMO_FLASHBACK',
    'TDS_DEMO_TYPES','TDS_DEMO_UNUSED','TDS_DEMO_EXTERNAL_BOOKS','TDS_DEMO_CONSTRAINTS',
    'TDS_DEMO_PARENT','TDS_DEMO_CHILD','TDS_DEMO_BOOK_COPY','TDS_DEMO_FLASHBACK')) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
  END LOOP;
END;
/
BEGIN
  FOR s IN (SELECT sequence_name FROM user_sequences WHERE sequence_name IN ('TDS_DEMO_SEQ','TDS_DEMO_SEQ_S12')) LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
  END LOOP;
END;
/
-- Synonym cleanup is commented out because CREATE/DROP SYNONYM may be unavailable on restricted school accounts.
-- BEGIN
--   FOR syn IN (SELECT synonym_name FROM user_synonyms WHERE synonym_name = 'TDS_BOOKS_SYNONYM') LOOP
--     EXECUTE IMMEDIATE 'DROP SYNONYM ' || syn.synonym_name;
--   END LOOP;
-- END;
-- /

PROMPT DD S15 L01 - string concatenation with ||, CONCAT(), DISTINCT
SELECT first_name || ' ' || last_name AS full_name FROM tds_person;
SELECT CONCAT(CONCAT(first_name, ' '), last_name) AS full_name FROM tds_person;
SELECT DISTINCT order_status FROM tds_customer_order;

PROMPT DD S16 L02 - WHERE, LOWER, UPPER, INITCAP
SELECT book_id, title, price FROM tds_book WHERE price > 300;
SELECT LOWER(email) AS lower_email, UPPER(last_name) AS upper_last_name, INITCAP(first_name) AS initcap_first_name FROM tds_person;

PROMPT DD S16 L03 - BETWEEN, LIKE, IN, IS NULL, IS NOT NULL
SELECT title, price FROM tds_book WHERE price BETWEEN 300 AND 500;
SELECT title FROM tds_book WHERE title LIKE '%Data%';
SELECT order_id, order_status FROM tds_customer_order WHERE order_status IN ('NEW','PAID','SHIPPED');
SELECT order_id FROM tds_customer_order WHERE delivery_note IS NULL;
SELECT order_id FROM tds_customer_order WHERE delivery_note IS NOT NULL;

PROMPT DD S17 L01 - AND, OR, NOT, parentheses
SELECT title, price, page_count FROM tds_book
WHERE (price > 300 AND page_count > 200) OR NOT category_id = 5;

PROMPT DD S17 L02 - ORDER BY ASC/DESC and multiple columns
SELECT title, price, page_count FROM tds_book ORDER BY price DESC;
SELECT title, price, page_count FROM tds_book ORDER BY price DESC, title ASC;

PROMPT DD S17 L03 - single-row and multi-row functions
SELECT title, ROUND(price * 1.21, 2) AS price_with_vat FROM tds_book;
SELECT MIN(price), MAX(price), AVG(price), SUM(price), COUNT(*) FROM tds_book;

PROMPT SQL S01 L01 - character functions and DUAL
SELECT LOWER('BOOKSTORE') AS lower_text,
       UPPER('bookstore') AS upper_text,
       INITCAP('online bookstore') AS initcap_text,
       CONCAT('Book', 'Store') AS concat_text,
       SUBSTR('BookStore', 1, 4) AS substr_text,
       LENGTH('BookStore') AS text_length,
       INSTR('BookStore', 'Store') AS instr_pos,
       LPAD('42', 5, '0') AS lpad_text,
       RPAD('Book', 8, '.') AS rpad_text,
       TRIM('  Book  ') AS trimmed_text,
       REPLACE('Old Book', 'Old', 'New') AS replaced_text
FROM dual;

PROMPT SQL S01 L02 - ROUND, TRUNC, MOD
SELECT title, price,
       ROUND(price, 2) AS rounded_2,
       TRUNC(price, 0) AS truncated_integer,
       ROUND(price, -3) AS rounded_thousands,
       MOD(page_count, 2) AS page_count_mod_2
FROM tds_book;

PROMPT SQL S01 L03 - date functions and SYSDATE
SELECT MONTHS_BETWEEN(SYSDATE, registered_at) AS months_registered,
       ADD_MONTHS(registered_at, 6) AS six_months_later,
       NEXT_DAY(registered_at, 'MONDAY') AS next_monday,
       LAST_DAY(registered_at) AS month_end,
       ROUND(registered_at, 'MONTH') AS rounded_month,
       TRUNC(registered_at, 'MONTH') AS first_day_of_month
FROM tds_customer;

PROMPT SQL S02 L01 - TO_CHAR, TO_NUMBER, TO_DATE
SELECT TO_CHAR(order_date, 'YYYY-MM-DD') AS order_date_text FROM tds_customer_order;
SELECT TO_NUMBER('1234.50') + 10 AS number_result FROM dual;
SELECT TO_DATE('2026-05-14', 'YYYY-MM-DD') AS converted_date FROM dual;

PROMPT SQL S02 L02 - NVL, NVL2, NULLIF, COALESCE
SELECT order_id,
       NVL(DBMS_LOB.SUBSTR(delivery_note, 4000, 1), 'No note') AS note_text,
       NVL2(employee_id, 'Assigned', 'Unassigned') AS employee_assignment,
       NULLIF(order_status, 'NEW') AS status_unless_new,
       COALESCE(DBMS_LOB.SUBSTR(delivery_note, 4000, 1), shipping_address, 'No text') AS first_available_text
FROM tds_customer_order;

PROMPT SQL S02 L03 - DECODE, CASE, IF-THEN-ELSE
SELECT order_id,
       DECODE(order_status, 'NEW', 'Open', 'PAID', 'Paid', 'Other') AS decoded_status,
       CASE WHEN total_amount >= 800 THEN 'High value' ELSE 'Normal value' END AS value_group
FROM tds_customer_order;
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM tds_customer_order;
  IF v_count > 0 THEN
    DBMS_OUTPUT.PUT_LINE('There are orders in the system.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('There are no orders in the system.');
  END IF;
END;
/

PROMPT SQL S03 L01 - NATURAL JOIN, CROSS JOIN
SELECT order_id, line_no, quantity FROM tds_customer_order NATURAL JOIN tds_order_item;
SELECT p.publisher_name, c.category_name FROM tds_publisher p CROSS JOIN tds_category c WHERE ROWNUM <= 10;

PROMPT SQL S03 L02 - JOIN USING and JOIN ON
SELECT order_id, line_no, quantity FROM tds_customer_order JOIN tds_order_item USING (order_id);
SELECT b.title, p.publisher_name FROM tds_book b JOIN tds_publisher p ON b.publisher_id = p.publisher_id;

PROMPT SQL S03 L03 - OUTER JOIN examples
SELECT b.title, oi.order_id FROM tds_book b LEFT OUTER JOIN tds_order_item oi ON b.book_id = oi.book_id;
SELECT b.title, oi.order_id FROM tds_order_item oi RIGHT OUTER JOIN tds_book b ON oi.book_id = b.book_id;
SELECT b.title, oi.order_id FROM tds_book b FULL OUTER JOIN tds_order_item oi ON b.book_id = oi.book_id;

PROMPT SQL S03 L04 - self join and hierarchical query on recursive category table
SELECT child.category_name AS child_category, parent.category_name AS parent_category
FROM tds_category child LEFT JOIN tds_category parent ON child.parent_category_id = parent.category_id;
SELECT LEVEL AS category_level, LPAD(' ', 2 * (LEVEL - 1)) || category_name AS category_tree
FROM tds_category
START WITH parent_category_id IS NULL
CONNECT BY PRIOR category_id = parent_category_id
ORDER SIBLINGS BY category_name;

PROMPT SQL S04 L02 - aggregate functions
SELECT AVG(price), COUNT(*), MIN(price), MAX(price), SUM(price), VARIANCE(price), STDDEV(price) FROM tds_book;

PROMPT SQL S04 L03 - COUNT variants and NVL
SELECT COUNT(*) AS all_orders, COUNT(employee_id) AS assigned_orders, COUNT(DISTINCT customer_id) AS distinct_customers FROM tds_customer_order;
SELECT AVG(NVL(discount_pct, 0)) AS avg_discount_with_null_as_zero FROM tds_order_item;

PROMPT SQL S05 L01 - GROUP BY and HAVING
SELECT customer_id, COUNT(*) AS order_count, SUM(total_amount) AS total_spent
FROM tds_customer_order
GROUP BY customer_id
HAVING SUM(total_amount) > 400;

PROMPT SQL S05 L02 - ROLLUP, CUBE, GROUPING SETS
SELECT order_status, employee_id, SUM(total_amount) AS total_amount
FROM tds_customer_order
GROUP BY ROLLUP(order_status, employee_id);
SELECT order_status, employee_id, SUM(total_amount) AS total_amount
FROM tds_customer_order
GROUP BY CUBE(order_status, employee_id);
SELECT order_status, employee_id, SUM(total_amount) AS total_amount
FROM tds_customer_order
GROUP BY GROUPING SETS ((order_status), (employee_id), ());

PROMPT SQL S05 L03 - UNION, UNION ALL, INTERSECT, MINUS
SELECT email FROM tds_person WHERE person_type = 'C'
UNION
SELECT email FROM tds_person WHERE person_type = 'E'
ORDER BY email;
SELECT email FROM tds_person WHERE person_type = 'C'
UNION ALL
SELECT email FROM tds_person WHERE person_type = 'E';
SELECT person_id FROM tds_person
INTERSECT
SELECT customer_id FROM tds_customer;
SELECT person_id FROM tds_person
MINUS
SELECT customer_id FROM tds_customer;

PROMPT SQL S06 L01 - subqueries: scalar, multi-column, EXISTS, NOT EXISTS
SELECT title, price FROM tds_book WHERE price > (SELECT AVG(price) FROM tds_book);
SELECT book_id, title, price FROM tds_book
WHERE (category_id, publisher_id) IN (SELECT category_id, publisher_id FROM tds_book WHERE price > 400);
SELECT c.customer_id FROM tds_customer c WHERE EXISTS (SELECT 1 FROM tds_customer_order o WHERE o.customer_id = c.customer_id);
SELECT c.customer_id FROM tds_customer c WHERE NOT EXISTS (SELECT 1 FROM tds_customer_order o WHERE o.customer_id = c.customer_id);

PROMPT SQL S06 L02 - single-row subquery
SELECT title, price FROM tds_book WHERE price = (SELECT MAX(price) FROM tds_book);

PROMPT SQL S06 L03 - multi-row subqueries IN, ANY, ALL and NULL comment
SELECT title FROM tds_book WHERE category_id IN (SELECT category_id FROM tds_category WHERE parent_category_id IS NOT NULL);
SELECT title, price FROM tds_book WHERE price > ANY (SELECT unit_price FROM tds_order_item);
SELECT title, price FROM tds_book WHERE price >= ALL (SELECT unit_price FROM tds_order_item WHERE unit_price IS NOT NULL);

PROMPT SQL S06 L04 - WITH AS
WITH order_totals AS (
  SELECT customer_id, SUM(total_amount) AS total_spent
  FROM tds_customer_order
  GROUP BY customer_id
)
SELECT customer_id, total_spent FROM order_totals WHERE total_spent > 400;

PROMPT SQL S07 L01 - INSERT forms
CREATE TABLE tds_demo_people (person_id NUMBER(10), full_name VARCHAR2(120));
INSERT INTO tds_demo_people VALUES (1, 'Manual Person');
INSERT INTO tds_demo_people (person_id, full_name) VALUES (2, 'Named Columns Person');
INSERT INTO tds_demo_people (person_id, full_name)
SELECT person_id, first_name || ' ' || last_name FROM tds_person WHERE person_id <= 3;
CREATE TABLE tds_demo_expensive_books AS SELECT book_id, title, price FROM tds_book WHERE price > 300;

PROMPT SQL S07 L02 - UPDATE and DELETE
UPDATE tds_demo_people SET full_name = INITCAP(full_name) WHERE person_id = 1;
DELETE FROM tds_demo_people WHERE person_id = 2;

PROMPT SQL S07 L03 - DEFAULT, MERGE, multi-table insert
CREATE TABLE tds_demo_stock (book_id NUMBER(10) PRIMARY KEY, stock_qty NUMBER(8) DEFAULT 0 NOT NULL);
INSERT INTO tds_demo_stock (book_id) VALUES (1);
MERGE INTO tds_demo_stock dst
USING (SELECT 1 AS book_id, 12 AS stock_qty FROM dual) src
ON (dst.book_id = src.book_id)
WHEN MATCHED THEN UPDATE SET dst.stock_qty = src.stock_qty
WHEN NOT MATCHED THEN INSERT (book_id, stock_qty) VALUES (src.book_id, src.stock_qty);
CREATE TABLE tds_demo_a (id NUMBER, label VARCHAR2(20));
CREATE TABLE tds_demo_b (id NUMBER, label VARCHAR2(20));
INSERT ALL
  INTO tds_demo_a (id, label) VALUES (book_id, 'A')
  INTO tds_demo_b (id, label) VALUES (book_id, 'B')
SELECT book_id FROM tds_book WHERE book_id <= 2;

PROMPT SQL S08 L01 - objects: table, index, constraint, view, sequence; synonym is commented due to privileges
CREATE TABLE tds_demo_alter (id NUMBER CONSTRAINT pk_tds_demo_alter PRIMARY KEY, name VARCHAR2(30) DEFAULT 'N/A' NOT NULL);
CREATE INDEX idx_tds_demo_alter_name ON tds_demo_alter(name);
CREATE OR REPLACE VIEW tds_v_order_totals AS SELECT order_status, SUM(total_amount) AS total_amount FROM tds_customer_order GROUP BY order_status;
CREATE SEQUENCE tds_demo_seq START WITH 100 INCREMENT BY 5 NOCACHE NOCYCLE;
select tds_demo_seq.NEXTVAL from dual; 
-- CREATE SYNONYM tds_books_synonym FOR tds_book; -- may fail without CREATE SYNONYM privilege
ALTER TABLE tds_demo_alter ADD created_at TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL;
CREATE TABLE tds_demo_rename_old (id NUMBER);
RENAME tds_demo_rename_old TO tds_demo_rename_new;
TRUNCATE TABLE tds_demo_rename_new;

PROMPT SQL S08 L01 optional external table template - commented because DIRECTORY privilege may be unavailable
-- CREATE TABLE tds_demo_external_books (
--   title VARCHAR2(200), price NUMBER(10,2)
-- ) ORGANIZATION EXTERNAL (
--   TYPE ORACLE_LOADER
--   DEFAULT DIRECTORY DATA_PUMP_DIR
--   ACCESS PARAMETERS (
--     RECORDS DELIMITED BY NEWLINE
--     FIELDS TERMINATED BY ','
--   )
--   LOCATION ('books.csv')
-- );

PROMPT SQL S08 L02 - datatype demo: timestamps, intervals, text, number, blob
CREATE TABLE tds_demo_types (
  id NUMBER,
  fixed_code CHAR(2),
  variable_text VARCHAR2(100),
  long_text CLOB,
  binary_data BLOB,
  created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
  created_at_tz TIMESTAMP WITH TIME ZONE,
  created_at_local TIMESTAMP WITH LOCAL TIME ZONE,
  revision_period INTERVAL YEAR TO MONTH,
  reading_period INTERVAL DAY TO SECOND
);
INSERT INTO tds_demo_types VALUES (
  1,
  'CZ',
  'demo',
  'clob text',
  TO_BLOB(UTL_RAW.CAST_TO_RAW('blob text')),
  SYSTIMESTAMP,
  SYSTIMESTAMP,
  SYSTIMESTAMP,
  INTERVAL '1-2' YEAR TO MONTH,
  INTERVAL '0 02:30:00' DAY TO SECOND
);
SELECT id, fixed_code, variable_text, created_at, created_at_tz, created_at_local,
       revision_period, reading_period
FROM tds_demo_types;

PROMPT SQL S08 L03 - ALTER TABLE, DROP, RENAME, FLASHBACK, DELETE, TRUNCATE, COMMENT, SET UNUSED
ALTER TABLE tds_demo_alter MODIFY name VARCHAR2(60);
ALTER TABLE tds_demo_alter ADD note VARCHAR2(100);
ALTER TABLE tds_demo_alter DROP COLUMN note;
COMMENT ON TABLE tds_demo_alter IS 'Demo table for ALTER and COMMENT commands.';
CREATE TABLE tds_demo_unused (id NUMBER, temporary_text VARCHAR2(50));
ALTER TABLE tds_demo_unused SET UNUSED (temporary_text);
DELETE FROM tds_demo_a WHERE id = 1;
TRUNCATE TABLE tds_demo_b;
-- FLASHBACK may be unavailable or disabled on some school accounts, so this demo is commented.
-- CREATE TABLE tds_demo_flashback (id NUMBER);
-- DROP TABLE tds_demo_flashback;
-- FLASHBACK TABLE tds_demo_flashback TO BEFORE DROP;
-- DROP TABLE tds_demo_flashback PURGE;

PROMPT SQL S10 L01 - named constraints and CTAS
CREATE TABLE tds_demo_constraints (
  id NUMBER CONSTRAINT pk_tds_demo_constraints PRIMARY KEY,
  code VARCHAR2(20) CONSTRAINT nn_tds_demo_constraints_code NOT NULL,
  email VARCHAR2(100),
  CONSTRAINT uq_tds_demo_constraints_email UNIQUE (email)
);
CREATE TABLE tds_demo_book_copy AS SELECT book_id, title, price FROM tds_book;
DROP TABLE tds_demo_book_copy PURGE;
DROP TABLE tds_demo_constraints PURGE;

PROMPT SQL S10 L02 - constraints including FK and CHECK
CREATE TABLE tds_demo_parent (id NUMBER CONSTRAINT pk_tds_demo_parent PRIMARY KEY);
CREATE TABLE tds_demo_child (
  id NUMBER CONSTRAINT pk_tds_demo_child PRIMARY KEY,
  parent_id NUMBER CONSTRAINT nn_tds_demo_child_parent NOT NULL,
  amount NUMBER CONSTRAINT ck_tds_demo_child_amount CHECK (amount >= 0),
  CONSTRAINT fk_tds_demo_child_parent FOREIGN KEY (parent_id) REFERENCES tds_demo_parent(id) ON DELETE CASCADE
);
DROP TABLE tds_demo_child PURGE;
DROP TABLE tds_demo_parent PURGE;

PROMPT SQL S10 L03 - USER_CONSTRAINTS
SELECT constraint_name, constraint_type, table_name FROM user_constraints WHERE table_name LIKE 'TDS_%' ORDER BY table_name, constraint_name;

PROMPT SQL S11 L01 - views: FORCE, NOFORCE, WITH CHECK OPTION, READ ONLY, simple and complex
CREATE OR REPLACE FORCE VIEW tds_v_force_demo AS SELECT book_id, title, price FROM tds_book;
CREATE OR REPLACE NOFORCE VIEW tds_v_noforce_demo AS SELECT person_id, email FROM tds_person;
CREATE OR REPLACE VIEW tds_v_book_prices AS SELECT book_id, title, price FROM tds_book WHERE price >= 0 WITH CHECK OPTION;
CREATE OR REPLACE VIEW tds_v_readonly_books AS SELECT book_id, title, price FROM tds_book WITH READ ONLY;
CREATE OR REPLACE VIEW tds_v_order_totals AS
SELECT o.order_id, p.first_name || ' ' || p.last_name AS customer_name, SUM(oi.quantity * oi.unit_price) AS calculated_total
FROM tds_customer_order o
JOIN tds_customer c ON o.customer_id = c.customer_id
JOIN tds_person p ON c.customer_id = p.person_id
JOIN tds_order_item oi ON o.order_id = oi.order_id
GROUP BY o.order_id, p.first_name, p.last_name;

PROMPT SQL S11 L03 - inline view
SELECT title, price FROM (SELECT title, price FROM tds_book WHERE price > 300) expensive_books ORDER BY price DESC;

PROMPT SQL S12 L01 - CREATE and ALTER SEQUENCE
CREATE SEQUENCE tds_demo_seq_s12
  START WITH 10
  INCREMENT BY 2
  NOMAXVALUE
  NOMINVALUE
  NOCYCLE
  NOCACHE;
SELECT tds_demo_seq_s12.NEXTVAL AS demo_sequence_value FROM dual;
ALTER SEQUENCE tds_demo_seq_s12 INCREMENT BY 1 NOCACHE NOCYCLE;
SELECT tds_demo_seq_s12.NEXTVAL AS demo_sequence_value_after_alter FROM dual;

PROMPT SQL S12 L02 - index and key objects
SELECT index_name, table_name, uniqueness FROM user_indexes WHERE table_name LIKE 'TDS_%' ORDER BY table_name, index_name;

PROMPT SQL S13 L01 - GRANT and REVOKE on a view to PUBLIC
CREATE OR REPLACE VIEW tds_v_grant_demo AS SELECT book_id, title FROM tds_book;
-- GRANT/REVOKE TO/FROM PUBLIC may fail without sufficient privileges on a school account.
-- GRANT SELECT ON tds_v_grant_demo TO PUBLIC;
-- REVOKE SELECT ON tds_v_grant_demo FROM PUBLIC;

PROMPT SQL S13 L03 - regular expressions
SELECT email FROM tds_person WHERE REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
SELECT REGEXP_REPLACE(phone, '[^0-9]', '') AS digits_only FROM tds_person WHERE phone IS NOT NULL;
SELECT REGEXP_INSTR(email, '@') AS at_position FROM tds_person;
SELECT REGEXP_SUBSTR(email, '[^@]+', 1, 1) AS email_user_name FROM tds_person;
SELECT REGEXP_COUNT(title, '[aeiouAEIOU]') AS vowel_count, title FROM tds_book;

PROMPT SQL S14 L01 - transaction commands
SAVEPOINT before_demo_update;
UPDATE tds_demo_stock SET stock_qty = stock_qty + 1 WHERE book_id = 1;
ROLLBACK TO before_demo_update;
COMMIT;

PROMPT SQL S15 L01 - old join syntax and old outer join syntax
SELECT b.title, p.publisher_name FROM tds_book b, tds_publisher p WHERE b.publisher_id = p.publisher_id;
SELECT b.title, oi.order_id FROM tds_book b, tds_order_item oi WHERE b.book_id = oi.book_id(+);

PROMPT SQL S16 L03 - recap query combining several concepts
WITH customer_spending AS (
  SELECT o.customer_id, SUM(o.total_amount) AS total_spent, COUNT(*) AS order_count
  FROM tds_customer_order o
  GROUP BY o.customer_id
)
SELECT p.first_name || ' ' || p.last_name AS customer_name,
       NVL(cs.total_spent, 0) AS total_spent,
       CASE WHEN NVL(cs.total_spent, 0) > 800 THEN 'VIP' ELSE 'STANDARD' END AS customer_group
FROM tds_customer c
JOIN tds_person p ON c.customer_id = p.person_id
LEFT JOIN customer_spending cs ON c.customer_id = cs.customer_id
ORDER BY total_spent DESC;

PROMPT Final cleanup of demo objects that are not needed after demonstration
-- The following cleanup is optional. Leave it commented if your teacher wants to inspect demo objects.
 DROP VIEW tds_v_book_prices;
 DROP VIEW tds_v_order_totals;
 DROP VIEW tds_v_readonly_books;
 DROP VIEW tds_v_force_demo;
 DROP VIEW tds_v_noforce_demo;
 DROP VIEW tds_v_grant_demo;
 DROP SYNONYM tds_books_synonym;
 DROP SEQUENCE tds_demo_seq;
 DROP TABLE tds_demo_types PURGE;
 DROP TABLE tds_demo_unused PURGE;
 DROP TABLE tds_demo_alter PURGE;
 DROP TABLE tds_demo_rename_new PURGE;
 DROP TABLE tds_demo_stock PURGE;
 DROP TABLE tds_demo_a PURGE;
 DROP TABLE tds_demo_b PURGE;
 DROP TABLE tds_demo_people PURGE;
 DROP TABLE tds_demo_expensive_books PURGE;
