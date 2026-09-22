CREATE TABLE bank_branch_2025160093 (
    branch_name VARCHAR2(15) PRIMARY KEY,
    branch_city VARCHAR2(15) NOT NULL,
    assets NUMBER NOT NULL
);

CREATE TABLE bank_customer_2025160093 (
    customer_name VARCHAR2(15) PRIMARY KEY,
    customer_street VARCHAR2(12) NOT NULL,
    customer_city VARCHAR2(15) NOT NULL
);

CREATE TABLE bank_account_2025160093 (
    account_number VARCHAR2(15) PRIMARY KEY,
    branch_name VARCHAR2(15) NOT NULL REFERENCES bank_branch_2025160093(branch_name),
    balance NUMBER NOT NULL
);

CREATE TABLE bank_loan_2025160093 (
    loan_number VARCHAR2(15) PRIMARY KEY,
    branch_name VARCHAR2(15) NOT NULL REFERENCES bank_branch_2025160093(branch_name),
    amount NUMBER NOT NULL
);

CREATE TABLE bank_depositor_2025160093 (
    customer_name VARCHAR2(15) REFERENCES bank_customer_2025160093(customer_name),
    account_number VARCHAR2(15) REFERENCES bank_account_2025160093(account_number),
    PRIMARY KEY (customer_name, account_number)
);

CREATE TABLE bank_borrower_2025160093 (
    customer_name VARCHAR2(15) REFERENCES bank_customer_2025160093(customer_name),
    loan_number VARCHAR2(15) REFERENCES bank_loan_2025160093(loan_number),
    PRIMARY KEY (customer_name, loan_number)
);

INSERT INTO bank_customer_2025160093 VALUES('Jones', 'Main', 'Harrison');
INSERT INTO bank_customer_2025160093 VALUES('Smith', 'Main', 'Rye');
INSERT INTO bank_customer_2025160093 VALUES('Hayes', 'Main', 'Harrison');
INSERT INTO bank_customer_2025160093 VALUES('Curry', 'North', 'Rye');
INSERT INTO bank_customer_2025160093 VALUES('Lindsay', 'Park', 'Pittsfield');
INSERT INTO bank_customer_2025160093 VALUES('Turner', 'Putnam', 'Stamford');
INSERT INTO bank_customer_2025160093 VALUES('Williams', 'Nassau', 'Princeton');
INSERT INTO bank_customer_2025160093 VALUES('Adams', 'Spring', 'Pittsfield');
INSERT INTO bank_customer_2025160093 VALUES('Johnson', 'Alma', 'Palo Alto');
INSERT INTO bank_customer_2025160093 VALUES('Glenn', 'Sand Hill', 'Woodside');
INSERT INTO bank_customer_2025160093 VALUES('Brooks', 'Senator', 'Brooklyn');
INSERT INTO bank_customer_2025160093 VALUES('Green', 'Walnut', 'Stamford');
INSERT INTO bank_customer_2025160093 VALUES('Jackson', 'University', 'Salt Lake');
INSERT INTO bank_customer_2025160093 VALUES('Majeris', 'First', 'Rye');
INSERT INTO bank_customer_2025160093 VALUES('McBride', 'Safety', 'Rye');

INSERT INTO bank_branch_2025160093 VALUES('Downtown', 'Brooklyn', 900000);
INSERT INTO bank_branch_2025160093 VALUES('Redwood', 'Palo Alto', 2100000);
INSERT INTO bank_branch_2025160093 VALUES('Perryridge', 'Horseneck', 1700000);
INSERT INTO bank_branch_2025160093 VALUES('Mianus', 'Horseneck', 400200);
INSERT INTO bank_branch_2025160093 VALUES('Round Hill', 'Horseneck', 8000000);
INSERT INTO bank_branch_2025160093 VALUES('Pownal', 'Bennington', 400000);
INSERT INTO bank_branch_2025160093 VALUES('North Town', 'Rye', 3700000);
INSERT INTO bank_branch_2025160093 VALUES('Brighton', 'Brooklyn', 7000000);
INSERT INTO bank_branch_2025160093 VALUES('Central', 'Rye', 400280);

INSERT INTO bank_account_2025160093 VALUES('A-101', 'Downtown', 500);
INSERT INTO bank_account_2025160093 VALUES('A-215', 'Mianus', 700);
INSERT INTO bank_account_2025160093 VALUES('A-102', 'Perryridge', 400);
INSERT INTO bank_account_2025160093 VALUES('A-305', 'Round Hill', 350);
INSERT INTO bank_account_2025160093 VALUES('A-201', 'Perryridge', 900);
INSERT INTO bank_account_2025160093 VALUES('A-222', 'Redwood', 700);
INSERT INTO bank_account_2025160093 VALUES('A-217', 'Brighton', 750);
INSERT INTO bank_account_2025160093 VALUES('A-333', 'Central', 850);
INSERT INTO bank_account_2025160093 VALUES('A-444', 'North Town', 625);

INSERT INTO bank_depositor_2025160093 VALUES('Johnson', 'A-101');
INSERT INTO bank_depositor_2025160093 VALUES('Smith', 'A-215');
INSERT INTO bank_depositor_2025160093 VALUES('Hayes', 'A-102');
INSERT INTO bank_depositor_2025160093 VALUES('Hayes', 'A-101');
INSERT INTO bank_depositor_2025160093 VALUES('Turner', 'A-305');
INSERT INTO bank_depositor_2025160093 VALUES('Johnson', 'A-201');
INSERT INTO bank_depositor_2025160093 VALUES('Jones', 'A-217');
INSERT INTO bank_depositor_2025160093 VALUES('Lindsay', 'A-222');
INSERT INTO bank_depositor_2025160093 VALUES('Majeris', 'A-333');
INSERT INTO bank_depositor_2025160093 VALUES('Smith', 'A-444');

INSERT INTO bank_loan_2025160093 VALUES('L-17', 'Downtown', 1000);
INSERT INTO bank_loan_2025160093 VALUES('L-23', 'Redwood', 2000);
INSERT INTO bank_loan_2025160093 VALUES('L-15', 'Perryridge', 1500);
INSERT INTO bank_loan_2025160093 VALUES('L-14', 'Downtown', 1500);
INSERT INTO bank_loan_2025160093 VALUES('L-93', 'Mianus', 500);
INSERT INTO bank_loan_2025160093 VALUES('L-11', 'Round Hill', 900);
INSERT INTO bank_loan_2025160093 VALUES('L-16', 'Perryridge', 1300);
INSERT INTO bank_loan_2025160093 VALUES('L-20', 'North Town', 7500);
INSERT INTO bank_loan_2025160093 VALUES('L-21', 'Central', 570);

INSERT INTO bank_borrower_2025160093 VALUES('Jones', 'L-17');
INSERT INTO bank_borrower_2025160093 VALUES('Smith', 'L-23');
INSERT INTO bank_borrower_2025160093 VALUES('Hayes', 'L-15');
INSERT INTO bank_borrower_2025160093 VALUES('Jackson', 'L-14');
INSERT INTO bank_borrower_2025160093 VALUES('Curry', 'L-93');
INSERT INTO bank_borrower_2025160093 VALUES('Smith', 'L-11');
INSERT INTO bank_borrower_2025160093 VALUES('Williams', 'L-17');
INSERT INTO bank_borrower_2025160093 VALUES('Adams', 'L-16');
INSERT INTO bank_borrower_2025160093 VALUES('McBride', 'L-20');
INSERT INTO bank_borrower_2025160093 VALUES('Smith', 'L-21');
COMMIT;

SELECT branch_name, branch_city FROM bank_branch_2025160093 WHERE assets > 1000000;

SELECT account_number, balance FROM bank_account_2025160093
WHERE branch_name = 'Downtown' OR balance BETWEEN 600 AND 750;

SELECT a.account_number
FROM bank_account_2025160093 a
JOIN bank_branch_2025160093 b ON b.branch_name = a.branch_name
WHERE b.branch_city = 'Rye';

SELECT DISTINCT l.loan_number
FROM bank_loan_2025160093 l
JOIN bank_borrower_2025160093 b ON b.loan_number = l.loan_number
JOIN bank_customer_2025160093 c ON c.customer_name = b.customer_name
WHERE l.amount >= 1000 AND c.customer_city = 'Harrison';

SELECT * FROM bank_account_2025160093 ORDER BY balance DESC, account_number;

SELECT * FROM bank_customer_2025160093 ORDER BY customer_city, customer_name;

SELECT customer_name FROM bank_depositor_2025160093
INTERSECT
SELECT customer_name FROM bank_borrower_2025160093;

SELECT c.* FROM bank_customer_2025160093 c
JOIN bank_depositor_2025160093 d ON d.customer_name = c.customer_name
UNION
SELECT c.* FROM bank_customer_2025160093 c
JOIN bank_borrower_2025160093 b ON b.customer_name = c.customer_name;

SELECT c.customer_name, c.customer_city
FROM bank_customer_2025160093 c
JOIN bank_borrower_2025160093 b ON b.customer_name = c.customer_name
MINUS
SELECT c.customer_name, c.customer_city
FROM bank_customer_2025160093 c
JOIN bank_depositor_2025160093 d ON d.customer_name = c.customer_name;

SELECT SUM(assets) AS total_assets FROM bank_branch_2025160093;

SELECT b.branch_name, AVG(a.balance) AS average_balance
FROM bank_branch_2025160093 b
LEFT JOIN bank_account_2025160093 a ON a.branch_name = b.branch_name
GROUP BY b.branch_name;

SELECT b.branch_city, AVG(a.balance) AS average_balance
FROM bank_branch_2025160093 b
LEFT JOIN bank_account_2025160093 a ON a.branch_name = b.branch_name
GROUP BY b.branch_city;

SELECT b.branch_name, MIN(l.amount) AS minimum_loan
FROM bank_branch_2025160093 b
LEFT JOIN bank_loan_2025160093 l ON l.branch_name = b.branch_name
GROUP BY b.branch_name;

SELECT b.branch_name, COUNT(l.loan_number) AS loan_count
FROM bank_branch_2025160093 b
LEFT JOIN bank_loan_2025160093 l ON l.branch_name = b.branch_name
GROUP BY b.branch_name;

SELECT d.customer_name, a.account_number
FROM bank_account_2025160093 a
JOIN bank_depositor_2025160093 d ON d.account_number = a.account_number
WHERE a.balance = (SELECT MAX(balance) FROM bank_account_2025160093);
