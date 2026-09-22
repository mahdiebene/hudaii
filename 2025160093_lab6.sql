SELECT c.customer_name, c.customer_street, c.customer_city, d.account_number
FROM bank_customer_2025160093 c
LEFT OUTER JOIN bank_depositor_2025160093 d ON d.customer_name = c.customer_name;

CREATE OR REPLACE VIEW cust_stam_2025160093 AS
SELECT customer_name, customer_street
FROM bank_customer_2025160093
WHERE customer_city = 'Stamford';

SELECT view_name, text FROM user_views;
SELECT * FROM cust_stam_2025160093;

CREATE OR REPLACE VIEW cust_stam_put_2025160093 AS
SELECT customer_name FROM cust_stam_2025160093
WHERE customer_street = 'Putnam';

SELECT * FROM cust_stam_put_2025160093;

SELECT column_name, updatable, insertable, deletable
FROM user_updatable_columns WHERE table_name = 'CUST_STAM_2025160093';

CREATE OR REPLACE TRIGGER stam_ins_2025160093
INSTEAD OF INSERT ON cust_stam_2025160093
FOR EACH ROW
BEGIN
    INSERT INTO bank_customer_2025160093
        (customer_name, customer_street, customer_city)
    VALUES (:NEW.customer_name, :NEW.customer_street, 'Stamford');
END;
/
