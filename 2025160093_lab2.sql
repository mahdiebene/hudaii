-- CSE302 Lab 2 | Student ID: 2025160093
-- Run once in SQL*Plus or SQL Developer's Run Script mode.

-- Task 1: Schema definition.
CREATE TABLE account_2025160093 (
    account_no CHAR(5) PRIMARY KEY,
    balance NUMBER NOT NULL CHECK (balance >= 0)
);

CREATE TABLE customer_2025160093 (
    customer_no CHAR(5) PRIMARY KEY,
    customer_name VARCHAR2(20) NOT NULL,
    customer_city VARCHAR2(10)
);

CREATE TABLE depositor_2025160093 (
    account_no CHAR(5),
    customer_no CHAR(5),
    PRIMARY KEY (account_no, customer_no)
);

-- Task 2(i).
ALTER TABLE customer_2025160093 ADD (date_of_birth DATE);
DESC customer_2025160093

-- Task 2(ii).
ALTER TABLE customer_2025160093 DROP COLUMN date_of_birth;
DESC customer_2025160093

-- Task 2(iii).
ALTER TABLE depositor_2025160093 RENAME COLUMN account_no TO a_no;
DESC depositor_2025160093
ALTER TABLE depositor_2025160093 RENAME COLUMN customer_no TO c_no;
DESC depositor_2025160093

-- Task 2(iv).
ALTER TABLE depositor_2025160093 ADD CONSTRAINT depositor_fk1
    FOREIGN KEY (a_no) REFERENCES account_2025160093(account_no);
DESC depositor_2025160093
ALTER TABLE depositor_2025160093 ADD CONSTRAINT depositor_fk2
    FOREIGN KEY (c_no) REFERENCES customer_2025160093(customer_no);
DESC depositor_2025160093

-- Task 3: Records from the manual.
INSERT INTO account_2025160093 VALUES('A-101', 12000);
INSERT INTO account_2025160093 VALUES('A-102', 6000);
INSERT INTO account_2025160093 VALUES('A-103', 2500);

INSERT INTO customer_2025160093 VALUES('C-101', 'Alice', 'Dhaka');
INSERT INTO customer_2025160093 VALUES('C-102', 'Annie', 'Dhaka');
INSERT INTO customer_2025160093 VALUES('C-103', 'Bob', 'Chittagong');
INSERT INTO customer_2025160093 VALUES('C-104', 'Charlie', 'Khulna');

INSERT INTO depositor_2025160093 VALUES('A-101', 'C-101');
INSERT INTO depositor_2025160093 VALUES('A-103', 'C-102');
INSERT INTO depositor_2025160093 VALUES('A-103', 'C-104');
INSERT INTO depositor_2025160093 VALUES('A-102', 'C-103');
COMMIT;

-- Task 4(i).
SELECT customer_name, customer_city FROM customer_2025160093;

-- Task 4(ii).
SELECT DISTINCT customer_city FROM customer_2025160093;

-- Task 4(iii).
SELECT account_no FROM account_2025160093 WHERE balance > 7000;

-- Task 4(iv).
SELECT customer_no, customer_name FROM customer_2025160093
WHERE customer_city = 'Khulna';

-- Task 4(v).
SELECT customer_no, customer_name FROM customer_2025160093
WHERE customer_city <> 'Dhaka';

-- Task 4(vi).
SELECT DISTINCT c.customer_name, c.customer_city
FROM customer_2025160093 c
JOIN depositor_2025160093 d ON d.c_no = c.customer_no
JOIN account_2025160093 a ON a.account_no = d.a_no
WHERE a.balance > 7000;

-- Task 4(vii).
SELECT DISTINCT c.customer_name, c.customer_city
FROM customer_2025160093 c
JOIN depositor_2025160093 d ON d.c_no = c.customer_no
JOIN account_2025160093 a ON a.account_no = d.a_no
WHERE a.balance > 7000 AND c.customer_city <> 'Khulna';

-- Task 4(viii).
SELECT a.account_no, a.balance
FROM account_2025160093 a
JOIN depositor_2025160093 d ON d.a_no = a.account_no
WHERE d.c_no = 'C-102';

-- Task 4(ix).
SELECT DISTINCT a.account_no, a.balance
FROM account_2025160093 a
JOIN depositor_2025160093 d ON d.a_no = a.account_no
JOIN customer_2025160093 c ON c.customer_no = d.c_no
WHERE c.customer_city IN ('Dhaka', 'Khulna');

-- Task 4(x): Correctly returns no rows for the supplied records.
SELECT c.* FROM customer_2025160093 c
WHERE NOT EXISTS (
    SELECT 1 FROM depositor_2025160093 d WHERE d.c_no = c.customer_no
);