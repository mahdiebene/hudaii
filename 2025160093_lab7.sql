CREATE TABLE books_2025160093 (
    book_id VARCHAR2(20) PRIMARY KEY,
    title VARCHAR2(50) NOT NULL,
    author_last_name VARCHAR2(25) NOT NULL,
    author_first_name VARCHAR2(25),
    rating NUMBER(2, 0) CHECK (rating BETWEEN 1 AND 10)
);

CREATE TABLE patrons_2025160093 (
    patron_id NUMBER(7, 0) PRIMARY KEY,
    last_name VARCHAR2(25) NOT NULL,
    first_name VARCHAR2(25),
    street_address VARCHAR2(40),
    city VARCHAR2(25),
    state VARCHAR2(2),
    zip VARCHAR2(10),
    location MDSYS.SDO_GEOMETRY
);

CREATE TABLE transactions_2025160093 (
    transaction_id NUMBER(7, 0) PRIMARY KEY,
    patron_id NUMBER(7, 0) NOT NULL REFERENCES patrons_2025160093(patron_id),
    book_id VARCHAR2(20) NOT NULL REFERENCES books_2025160093(book_id),
    transaction_date DATE NOT NULL,
    transaction_type NUMBER(7, 0) NOT NULL CHECK (transaction_type IN (1, 2))
);

CREATE TABLE active_loans_2025160093 (
    book_id VARCHAR2(20) PRIMARY KEY REFERENCES books_2025160093(book_id),
    patron_id NUMBER(7, 0) NOT NULL REFERENCES patrons_2025160093(patron_id),
    checkout_date DATE NOT NULL
);

CREATE OR REPLACE TRIGGER library_tx_2025160093
BEFORE INSERT OR UPDATE OR DELETE ON transactions_2025160093
FOR EACH ROW
DECLARE
    v_book_id books_2025160093.book_id%TYPE;
BEGIN
    IF UPDATING OR DELETING THEN
        RAISE_APPLICATION_ERROR(-20030, 'Transaction history is append-only.');
    END IF;

    SELECT book_id INTO v_book_id FROM books_2025160093
    WHERE book_id = :NEW.book_id FOR UPDATE;

    IF :NEW.transaction_type = 1 THEN
        BEGIN
            INSERT INTO active_loans_2025160093
            VALUES (:NEW.book_id, :NEW.patron_id, :NEW.transaction_date);
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                RAISE_APPLICATION_ERROR(-20031, 'Book is already checked out.');
        END;
    ELSIF :NEW.transaction_type = 2 THEN
        DELETE FROM active_loans_2025160093
        WHERE book_id = :NEW.book_id AND patron_id = :NEW.patron_id
          AND checkout_date <= :NEW.transaction_date;
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20032, 'No matching checkout for this return.');
        END IF;
    END IF;
END;
/

CREATE TABLE client_2025160093 (
    clientNo NUMBER(7, 0) PRIMARY KEY,
    clientName VARCHAR2(50) NOT NULL,
    clientAddr VARCHAR2(100),
    clientBalance NUMBER(12, 2)
);

CREATE TABLE employee_2025160093 (
    empNo NUMBER(7, 0) PRIMARY KEY,
    empName VARCHAR2(50) NOT NULL,
    empPhone VARCHAR2(20),
    empCommissionRate NUMBER(5, 4) CHECK (empCommissionRate BETWEEN 0 AND 1)
);

CREATE TABLE product_2025160093 (
    prodNo NUMBER(7, 0) PRIMARY KEY,
    prodName VARCHAR2(50),
    prodPrice NUMBER(12, 2) CHECK (prodPrice >= 0)
);

CREATE TABLE orders_2025160093 (
    orderNo NUMBER(7, 0) PRIMARY KEY,
    orderDate DATE,
    orderAddr VARCHAR2(100),
    clientNo NUMBER(7, 0) NOT NULL REFERENCES client_2025160093(clientNo),
    empNo NUMBER(7, 0) NOT NULL REFERENCES employee_2025160093(empNo)
);

CREATE TABLE order_product_2025160093 (
    orderNo NUMBER(7, 0) REFERENCES orders_2025160093(orderNo),
    prodNo NUMBER(7, 0) REFERENCES product_2025160093(prodNo),
    PRIMARY KEY (orderNo, prodNo)
);

SELECT table_name, constraint_name, constraint_type, r_constraint_name
FROM user_constraints
WHERE table_name IN (
    'BOOKS_2025160093', 'PATRONS_2025160093', 'TRANSACTIONS_2025160093',
    'ACTIVE_LOANS_2025160093', 'CLIENT_2025160093', 'EMPLOYEE_2025160093',
    'PRODUCT_2025160093', 'ORDERS_2025160093', 'ORDER_PRODUCT_2025160093'
)
ORDER BY table_name, constraint_type;
