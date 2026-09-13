-- TDS I Project - Online Bookstore
-- CREATE SCRIPT for Oracle SQL Developer
-- Author: Richard Chovanec
-- Version: 12 tables, TDS_ prefix, no INTERVAL datatypes

-- Drop tables in dependency order. Run only if recreating the schema.
BEGIN
  FOR t IN (
    SELECT table_name FROM user_tables
    WHERE table_name IN (
      'TDS_PAYMENT','TDS_ORDER_ITEM','TDS_CUSTOMER_ORDER','TDS_BOOK_AUTHOR','TDS_BOOK',
      'TDS_CATEGORY','TDS_AUTHOR','TDS_PUBLISHER','TDS_EMPLOYEE_SALARY_HISTORY',
      'TDS_EMPLOYEE','TDS_CUSTOMER','TDS_PERSON'
    )
  ) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
  END LOOP;
END;
/

-- Drop sequences if they already exist.
BEGIN
  FOR s IN (
    SELECT sequence_name FROM user_sequences
    WHERE sequence_name IN (
      'TDS_SEQ_PERSON','TDS_SEQ_PUBLISHER','TDS_SEQ_AUTHOR','TDS_SEQ_CATEGORY',
      'TDS_SEQ_BOOK','TDS_SEQ_ORDER','TDS_SEQ_PAYMENT'
    )
  ) LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
  END LOOP;
END;
/

CREATE SEQUENCE tds_seq_person START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE tds_seq_publisher START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE tds_seq_author START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE tds_seq_category START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE tds_seq_book START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE tds_seq_order START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE tds_seq_payment START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE TABLE tds_person (
  person_id       NUMBER(10) CONSTRAINT pk_tds_person PRIMARY KEY,
  first_name      VARCHAR2(50) CONSTRAINT nn_tds_person_first_name NOT NULL,
  last_name       VARCHAR2(50) CONSTRAINT nn_tds_person_last_name NOT NULL,
  email           VARCHAR2(120) CONSTRAINT nn_tds_person_email NOT NULL,
  phone           VARCHAR2(30),
  birth_date      DATE,
  profile_photo   BLOB,
  person_type     CHAR(1) DEFAULT 'C' CONSTRAINT nn_tds_person_type NOT NULL,
  created_at      TIMESTAMP DEFAULT SYSTIMESTAMP CONSTRAINT nn_tds_person_created_at NOT NULL,
  CONSTRAINT uq_tds_person_email UNIQUE (email),
  CONSTRAINT ck_tds_person_type CHECK (person_type IN ('C','E')),
  CONSTRAINT ck_tds_person_email CHECK (REGEXP_LIKE(email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'))
);

CREATE TABLE tds_customer (
  customer_id       NUMBER(10) CONSTRAINT pk_tds_customer PRIMARY KEY,
  loyalty_points    NUMBER(8) DEFAULT 0 CONSTRAINT nn_tds_customer_points NOT NULL,
  registered_at     DATE DEFAULT SYSDATE CONSTRAINT nn_tds_customer_registered NOT NULL,
  preferred_contact VARCHAR2(20) DEFAULT 'EMAIL' CONSTRAINT nn_tds_customer_contact NOT NULL,
  CONSTRAINT fk_tds_customer_person FOREIGN KEY (customer_id) REFERENCES tds_person(person_id) ON DELETE CASCADE,
  CONSTRAINT ck_tds_customer_points CHECK (loyalty_points >= 0),
  CONSTRAINT ck_tds_customer_contact CHECK (preferred_contact IN ('EMAIL','PHONE','NONE'))
);

CREATE TABLE tds_employee (
  employee_id       NUMBER(10) CONSTRAINT pk_tds_employee PRIMARY KEY,
  job_title         VARCHAR2(80) CONSTRAINT nn_tds_employee_job_title NOT NULL,
  hire_date         DATE DEFAULT SYSDATE CONSTRAINT nn_tds_employee_hire_date NOT NULL,
  salary            NUMBER(10,2) CONSTRAINT nn_tds_employee_salary NOT NULL,
  employment_status VARCHAR2(20) DEFAULT 'ACTIVE' CONSTRAINT nn_tds_employee_status NOT NULL,
  CONSTRAINT fk_tds_employee_person FOREIGN KEY (employee_id) REFERENCES tds_person(person_id) ON DELETE CASCADE,
  CONSTRAINT ck_tds_employee_salary CHECK (salary > 0),
  CONSTRAINT ck_tds_employee_status CHECK (employment_status IN ('ACTIVE','ON_LEAVE','TERMINATED'))
);

CREATE TABLE tds_employee_salary_history (
  employee_id      NUMBER(10) CONSTRAINT nn_tds_salary_employee NOT NULL,
  valid_from       DATE CONSTRAINT nn_tds_salary_valid_from NOT NULL,
  valid_to         DATE,
  old_salary       NUMBER(10,2),
  new_salary       NUMBER(10,2) CONSTRAINT nn_tds_salary_new_salary NOT NULL,
  change_reason    VARCHAR2(200),
  changed_at       TIMESTAMP DEFAULT SYSTIMESTAMP CONSTRAINT nn_tds_salary_changed_at NOT NULL,
  CONSTRAINT pk_tds_employee_salary_history PRIMARY KEY (employee_id, valid_from),
  CONSTRAINT fk_tds_salary_employee FOREIGN KEY (employee_id) REFERENCES tds_employee(employee_id) ON DELETE CASCADE,
  CONSTRAINT ck_tds_salary_dates CHECK (valid_to IS NULL OR valid_to >= valid_from),
  CONSTRAINT ck_tds_salary_amounts CHECK (new_salary > 0 AND (old_salary IS NULL OR old_salary > 0))
);

CREATE TABLE tds_publisher (
  publisher_id     NUMBER(10) CONSTRAINT pk_tds_publisher PRIMARY KEY,
  publisher_name   VARCHAR2(120) CONSTRAINT nn_tds_publisher_name NOT NULL,
  country_code     CHAR(2) CONSTRAINT nn_tds_publisher_country NOT NULL,
  website_url      VARCHAR2(200),
  created_at       TIMESTAMP DEFAULT SYSTIMESTAMP CONSTRAINT nn_tds_publisher_created_at NOT NULL,
  CONSTRAINT uq_tds_publisher_name UNIQUE (publisher_name)
);

CREATE TABLE tds_author (
  author_id        NUMBER(10) CONSTRAINT pk_tds_author PRIMARY KEY,
  first_name       VARCHAR2(50) CONSTRAINT nn_tds_author_first_name NOT NULL,
  last_name        VARCHAR2(50) CONSTRAINT nn_tds_author_last_name NOT NULL,
  biography        CLOB,
  birth_date       DATE,
  nationality      VARCHAR2(60)
);

CREATE TABLE tds_category (
  category_id        NUMBER(10) CONSTRAINT pk_tds_category PRIMARY KEY,
  parent_category_id NUMBER(10),
  category_name      VARCHAR2(100) CONSTRAINT nn_tds_category_name NOT NULL,
  is_active          CHAR(1) DEFAULT 'Y' CONSTRAINT nn_tds_category_active NOT NULL,
  CONSTRAINT fk_tds_category_parent FOREIGN KEY (parent_category_id) REFERENCES tds_category(category_id),
  CONSTRAINT uq_tds_category_name UNIQUE (category_name),
  CONSTRAINT ck_tds_category_active CHECK (is_active IN ('Y','N')),
  CONSTRAINT ck_tds_category_not_self CHECK (parent_category_id IS NULL OR parent_category_id <> category_id)
);

CREATE TABLE tds_book (
  book_id          NUMBER(10) CONSTRAINT pk_tds_book PRIMARY KEY,
  publisher_id     NUMBER(10) CONSTRAINT nn_tds_book_publisher NOT NULL,
  category_id      NUMBER(10) CONSTRAINT nn_tds_book_category NOT NULL,
  isbn             VARCHAR2(20) CONSTRAINT nn_tds_book_isbn NOT NULL,
  title            VARCHAR2(200) CONSTRAINT nn_tds_book_title NOT NULL,
  publication_date DATE,
  page_count       NUMBER(5),
  price            NUMBER(10,2) CONSTRAINT nn_tds_book_price NOT NULL,
  tax_rate         NUMBER(5,2) DEFAULT 10 CONSTRAINT nn_tds_book_tax_rate NOT NULL,
  digital_file     BLOB,
  description      CLOB,
  estimated_reading_minutes NUMBER(5),
  next_revision_at TIMESTAMP,
  created_at       TIMESTAMP DEFAULT SYSTIMESTAMP CONSTRAINT nn_tds_book_created_at NOT NULL,
  CONSTRAINT fk_tds_book_publisher FOREIGN KEY (publisher_id) REFERENCES tds_publisher(publisher_id),
  CONSTRAINT fk_tds_book_category FOREIGN KEY (category_id) REFERENCES tds_category(category_id),
  CONSTRAINT uq_tds_book_isbn UNIQUE (isbn),
  CONSTRAINT ck_tds_book_price CHECK (price >= 0),
  CONSTRAINT ck_tds_book_page_count CHECK (page_count IS NULL OR page_count > 0),
  CONSTRAINT ck_tds_book_reading_minutes CHECK (estimated_reading_minutes IS NULL OR estimated_reading_minutes > 0),
  CONSTRAINT ck_tds_book_revision CHECK (next_revision_at IS NULL OR publication_date IS NULL OR CAST(next_revision_at AS DATE) >= publication_date),
  CONSTRAINT ck_tds_book_tax_rate CHECK (tax_rate BETWEEN 0 AND 30)
);

CREATE TABLE tds_book_author (
  book_id     NUMBER(10) CONSTRAINT nn_tds_book_author_book NOT NULL,
  author_id   NUMBER(10) CONSTRAINT nn_tds_book_author_author NOT NULL,
  CONSTRAINT pk_tds_book_author PRIMARY KEY (book_id, author_id),
  CONSTRAINT fk_tds_book_author_book FOREIGN KEY (book_id) REFERENCES tds_book(book_id) ON DELETE CASCADE,
  CONSTRAINT fk_tds_book_author_author FOREIGN KEY (author_id) REFERENCES tds_author(author_id) ON DELETE CASCADE
);

CREATE TABLE tds_customer_order (
  order_id          NUMBER(10) CONSTRAINT pk_tds_customer_order PRIMARY KEY,
  customer_id       NUMBER(10) CONSTRAINT nn_tds_order_customer NOT NULL,
  employee_id       NUMBER(10),
  order_date        DATE DEFAULT SYSDATE CONSTRAINT nn_tds_order_date NOT NULL,
  order_status      VARCHAR2(20) DEFAULT 'NEW' CONSTRAINT nn_tds_order_status NOT NULL,
  shipping_address  VARCHAR2(250) CONSTRAINT nn_tds_order_shipping_address NOT NULL,
  delivery_note     CLOB,
  total_amount      NUMBER(12,2) DEFAULT 0 CONSTRAINT nn_tds_order_total NOT NULL,
  CONSTRAINT fk_tds_order_customer FOREIGN KEY (customer_id) REFERENCES tds_customer(customer_id),
  CONSTRAINT fk_tds_order_employee FOREIGN KEY (employee_id) REFERENCES tds_employee(employee_id) ON DELETE SET NULL,
  CONSTRAINT ck_tds_order_status CHECK (order_status IN ('NEW','PAID','SHIPPED','DELIVERED','CANCELLED')),
  CONSTRAINT ck_tds_order_total CHECK (total_amount >= 0)
);

CREATE TABLE tds_order_item (
  order_id       NUMBER(10) CONSTRAINT nn_tds_item_order NOT NULL,
  line_no        NUMBER(4) CONSTRAINT nn_tds_item_line_no NOT NULL,
  book_id        NUMBER(10) CONSTRAINT nn_tds_item_book NOT NULL,
  quantity       NUMBER(6) CONSTRAINT nn_tds_item_quantity NOT NULL,
  unit_price     NUMBER(10,2) CONSTRAINT nn_tds_item_unit_price NOT NULL,
  discount_pct   NUMBER(5,2) DEFAULT 0 CONSTRAINT nn_tds_item_discount NOT NULL,
  CONSTRAINT pk_tds_order_item PRIMARY KEY (order_id, line_no),
  CONSTRAINT fk_tds_item_order FOREIGN KEY (order_id) REFERENCES tds_customer_order(order_id) ON DELETE CASCADE,
  CONSTRAINT fk_tds_item_book FOREIGN KEY (book_id) REFERENCES tds_book(book_id),
  CONSTRAINT ck_tds_item_quantity CHECK (quantity > 0),
  CONSTRAINT ck_tds_item_unit_price CHECK (unit_price >= 0),
  CONSTRAINT ck_tds_item_discount CHECK (discount_pct BETWEEN 0 AND 100)
);

CREATE TABLE tds_payment (
  payment_id            NUMBER(10) CONSTRAINT pk_tds_payment PRIMARY KEY,
  order_id              NUMBER(10) CONSTRAINT nn_tds_payment_order NOT NULL,
  paid_at               TIMESTAMP DEFAULT SYSTIMESTAMP,
  amount                NUMBER(12,2) CONSTRAINT nn_tds_payment_amount NOT NULL,
  payment_method        VARCHAR2(20) CONSTRAINT nn_tds_payment_method NOT NULL,
  card_transaction_code VARCHAR2(60),
  bank_transfer_code    VARCHAR2(60),
  gift_card_code        VARCHAR2(60),
  CONSTRAINT fk_tds_payment_order FOREIGN KEY (order_id) REFERENCES tds_customer_order(order_id) ON DELETE CASCADE,
  CONSTRAINT ck_tds_payment_amount CHECK (amount > 0),
  CONSTRAINT ck_tds_payment_method CHECK (payment_method IN ('CARD','BANK_TRANSFER','GIFT_CARD')),
  CONSTRAINT ck_tds_payment_arc CHECK (
    (payment_method = 'CARD' AND card_transaction_code IS NOT NULL AND bank_transfer_code IS NULL AND gift_card_code IS NULL) OR
    (payment_method = 'BANK_TRANSFER' AND card_transaction_code IS NULL AND bank_transfer_code IS NOT NULL AND gift_card_code IS NULL) OR
    (payment_method = 'GIFT_CARD' AND card_transaction_code IS NULL AND bank_transfer_code IS NULL AND gift_card_code IS NOT NULL)
  )
);

-- Subtype consistency triggers. They enforce that TDS_CUSTOMER rows can only reference
-- TDS_PERSON rows with person_type = 'C', and TDS_EMPLOYEE rows can only reference
-- TDS_PERSON rows with person_type = 'E'.
CREATE OR REPLACE TRIGGER trg_tds_customer_person_type
BEFORE INSERT OR UPDATE OF customer_id ON tds_customer
FOR EACH ROW
DECLARE
  v_person_type tds_person.person_type%TYPE;
BEGIN
  SELECT person_type INTO v_person_type
  FROM tds_person
  WHERE person_id = :NEW.customer_id;

  IF v_person_type <> 'C' THEN
    RAISE_APPLICATION_ERROR(-20001, 'TDS_CUSTOMER must reference TDS_PERSON with person_type = C.');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_tds_employee_person_type
BEFORE INSERT OR UPDATE OF employee_id ON tds_employee
FOR EACH ROW
DECLARE
  v_person_type tds_person.person_type%TYPE;
BEGIN
  SELECT person_type INTO v_person_type
  FROM tds_person
  WHERE person_id = :NEW.employee_id;

  IF v_person_type <> 'E' THEN
    RAISE_APPLICATION_ERROR(-20002, 'TDS_EMPLOYEE must reference TDS_PERSON with person_type = E.');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_tds_person_type_protect
BEFORE UPDATE OF person_type ON tds_person
FOR EACH ROW
DECLARE
  v_customer_count NUMBER;
  v_employee_count NUMBER;
BEGIN
  IF :OLD.person_type <> :NEW.person_type THEN
    SELECT COUNT(*) INTO v_customer_count
    FROM tds_customer
    WHERE customer_id = :OLD.person_id;

    SELECT COUNT(*) INTO v_employee_count
    FROM tds_employee
    WHERE employee_id = :OLD.person_id;

    IF v_customer_count > 0 OR v_employee_count > 0 THEN
      RAISE_APPLICATION_ERROR(-20003, 'Cannot change TDS_PERSON.person_type after subtype row exists.');
    END IF;
  END IF;
END;
/

CREATE INDEX idx_tds_book_title ON tds_book(title);
CREATE INDEX idx_tds_order_customer ON tds_customer_order(customer_id);
CREATE INDEX idx_tds_payment_order ON tds_payment(order_id);
CREATE INDEX idx_tds_category_parent ON tds_category(parent_category_id);

COMMENT ON TABLE tds_person IS 'Supertype table for customers and employees.';
COMMENT ON TABLE tds_customer IS 'Customer subtype of TDS_PERSON.';
COMMENT ON TABLE tds_employee IS 'Employee subtype of TDS_PERSON. Employees are not nested under managers in this simplified model.';
COMMENT ON TABLE tds_employee_salary_history IS 'Historical salary changes for employees.';
COMMENT ON TABLE tds_category IS 'Recursive book category hierarchy.';
COMMENT ON TABLE tds_book_author IS 'Many-to-many relationship between books and authors without relationship attributes.';
COMMENT ON TABLE tds_order_item IS 'Identifying child table of TDS_CUSTOMER_ORDER and many-to-many relationship between orders and books with relationship attributes.';
COMMENT ON TABLE tds_payment IS 'Payment table using an ARC-like exclusive relationship between payment method and method-specific code.';
