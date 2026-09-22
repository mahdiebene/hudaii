-- CSE302 Lab 6 | Student ID: 2025160093
-- Prerequisite: run 2025160093_lab3.sql once.
-- Run Activity 1 and 2 as the owner of the banking tables.
-- Activity 3 contains separate DBA/owner/Alice sessions: run those sections
-- individually in SQL*Plus, not the entire file under a single account.

-- Activity 1: Include account holders and customers without accounts.
SELECT c.customer_name, c.customer_street, c.customer_city, d.account_number
FROM bank_customer_2025160093 c
LEFT OUTER JOIN bank_depositor_2025160093 d ON d.customer_name = c.customer_name;

-- Activity 2: Views. Shortened names stay within Oracle 10g's 30-byte limit.
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

-- Is the view updatable? Yes: it is a simple single-table projection/filter.
SELECT column_name, updatable, insertable, deletable
FROM user_updatable_columns WHERE table_name = 'CUST_STAM_2025160093';

-- However, the supplied banking schema makes customer_city NOT NULL.
-- The manual's two-column INSERT would therefore raise ORA-01400 without
-- a default or trigger. This INSTEAD OF trigger supplies the required city,
-- making the requested INSERT succeed and remain visible through the view.
CREATE OR REPLACE TRIGGER stam_ins_2025160093
INSTEAD OF INSERT ON cust_stam_2025160093
FOR EACH ROW
BEGIN
    INSERT INTO bank_customer_2025160093
        (customer_name, customer_street, customer_city)
    VALUES (:NEW.customer_name, :NEW.customer_street, 'Stamford');
END;
/

/*
Activity 3: Authorization. Execute each session below separately.
Local user ALICE_2025160093 is used for Oracle XE 10g or an Oracle PDB.
The manual's C##ALICE name is only for a common user in a 12c+ CDB root;
it is not valid as a local PDB user and is unnecessary for these exercises.
Only CREATE SESSION is needed by Alice; RESOURCE and UNLIMITED TABLESPACE
would grant unnecessary privileges. Supply your own password at the prompt.

3(a). DBA session connected to the SAME database/PDB as the table owner:

ACCEPT alice_password CHAR PROMPT 'New Alice password: ' HIDE
CREATE USER alice_2025160093 IDENTIFIED BY "&alice_password";
UNDEFINE alice_password
GRANT CREATE SESSION TO alice_2025160093;

3(b). Table-owner session:

GRANT SELECT, INSERT ON cust_stam_2025160093 TO alice_2025160093;
SELECT grantee, table_name, privilege FROM user_tab_privs
WHERE grantee = 'ALICE_2025160093';

3(c). Log in as ALICE_2025160093 in a separate SQL*Plus session.
Resolve the actual owner from the grant instead of hard-coding a schema:

COLUMN owner NEW_VALUE lab_owner NOPRINT
SELECT table_schema AS owner FROM all_tab_privs
WHERE grantee = USER AND table_name = 'CUST_STAM_2025160093'
  AND privilege = 'SELECT';
SELECT * FROM &lab_owner..cust_stam_2025160093;
INSERT INTO &lab_owner..cust_stam_2025160093 VALUES('Peter', 'Bricklane');
COMMIT;
SELECT * FROM &lab_owner..cust_stam_2025160093;
SELECT * FROM user_tab_privs;
UNDEFINE lab_owner

3(d). Return to the table-owner session:

REVOKE INSERT ON cust_stam_2025160093 FROM alice_2025160093;
SELECT grantee, table_name, privilege FROM user_tab_privs
WHERE grantee = 'ALICE_2025160093';

After revocation, SELECT remains, INSERT disappears. Alice can still query
the view but an attempted INSERT now raises ORA-01031.
*/