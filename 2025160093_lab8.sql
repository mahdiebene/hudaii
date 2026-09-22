-- CSE302 Lab 8 | Student ID: 2025160093
-- Run the DDL once in the parsing schema of an Oracle APEX workspace.
-- Forms, reports, file-upload items, authentication/authorization schemes and
-- the final application export require App Builder; SQL alone does not create
-- those GUI pages. Exact page/item configuration is documented below.

-- Activities 6-7: tables and sequences.
CREATE TABLE country_2025160093 (
    country_code NUMBER PRIMARY KEY,
    country_name VARCHAR2(50) NOT NULL,
    file_lob BLOB,
    file_name VARCHAR2(255),
    file_mimetype VARCHAR2(255),
    file_updatedate VARCHAR2(30),
    file_characterset VARCHAR2(128)
);

CREATE TABLE player_2025160093 (
    player_id NUMBER PRIMARY KEY,
    player_name VARCHAR2(50) NOT NULL,
    country_code NUMBER REFERENCES country_2025160093(country_code),
    file_lob BLOB,
    file_name VARCHAR2(255),
    file_mimetype VARCHAR2(255),
    file_updatedate VARCHAR2(30),
    file_characterset VARCHAR2(128)
);

CREATE SEQUENCE country_seq_2025160093 START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE player_seq_2025160093 START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER country_bi_2025160093
BEFORE INSERT ON country_2025160093
FOR EACH ROW
BEGIN
    IF :NEW.country_code IS NULL THEN
        SELECT country_seq_2025160093.NEXTVAL INTO :NEW.country_code FROM dual;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER player_bi_2025160093
BEFORE INSERT ON player_2025160093
FOR EACH ROW
BEGIN
    IF :NEW.player_id IS NULL THEN
        SELECT player_seq_2025160093.NEXTVAL INTO :NEW.player_id FROM dual;
    END IF;
END;
/

-- Keep the handout's VARCHAR2 timestamp metadata in a consistent format.
CREATE OR REPLACE TRIGGER country_file_2025160093
BEFORE INSERT OR UPDATE OF file_lob ON country_2025160093
FOR EACH ROW
BEGIN
    :NEW.file_updatedate := TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3');
END;
/

CREATE OR REPLACE TRIGGER player_file_2025160093
BEFORE INSERT OR UPDATE OF file_lob ON player_2025160093
FOR EACH ROW
BEGIN
    :NEW.file_updatedate := TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3');
END;
/

-- Supplemental records for demonstrating the forms and reports.
INSERT INTO country_2025160093 (country_name) VALUES('Bangladesh');
INSERT INTO country_2025160093 (country_name) VALUES('India');
INSERT INTO player_2025160093 (player_name, country_code)
SELECT 'Shakib Al Hasan', country_code FROM country_2025160093
WHERE country_name = 'Bangladesh';
INSERT INTO player_2025160093 (player_name, country_code)
SELECT 'Virat Kohli', country_code FROM country_2025160093
WHERE country_name = 'India';
COMMIT;

-- Activities 1-5 and 8: App Builder configuration.
-- 1. Log in, create an application using this parsing schema.
-- 2. Page 1: country interactive report; Page 2: country form, primary key
--    P2_COUNTRY_CODE, table COUNTRY_2025160093, automatic row processing.
-- 3. Page 3: player form, key P3_PLAYER_ID, table PLAYER_2025160093,
--    automatic row processing; link it to the report on Page 5.
-- 4. Page 4: Master Detail, COUNTRY_2025160093 as master and
--    PLAYER_2025160093 as detail, linked on COUNTRY_CODE.
-- 5. Page 5: report from this query (retains players with no country).
SELECT p.player_id, p.player_name, c.country_name,
       p.file_name, p.file_mimetype, p.file_updatedate
FROM player_2025160093 p
LEFT JOIN country_2025160093 c ON c.country_code = p.country_code
ORDER BY p.player_name;

-- Country report source.
SELECT country_code, country_name, file_name, file_mimetype, file_updatedate
FROM country_2025160093 ORDER BY country_name;

-- Activity 9: SQL Query LOV for the P3_COUNTRY_CODE Select List.
-- Display column = DISPLAY_VALUE; return column = RETURN_VALUE.
SELECT country_name AS display_value, country_code AS return_value
FROM country_2025160093 ORDER BY country_name;

/*
Activity 10: File upload and image report, configured in App Builder.
On Page 2 create P2_FILE_LOB; on Page 3 create P3_FILE_LOB:
  Type: File Browse / File Upload (version-dependent label).
  Storage: BLOB column specified in Item Source; source column FILE_LOB.
  MIME Type Column: FILE_MIMETYPE; Filename Column: FILE_NAME;
  Character Set Column: FILE_CHARACTERSET; allow a single file.
  Leave the DATE-type "BLOB Last Updated" mapping unset: the manual's
  FILE_UPDATEDATE is VARCHAR2 and is maintained by the triggers above.
  Restrict accepted image types to image/png and image/jpeg.
  Submit via the form's automatic row-processing process to store the BLOB.

Use this SQL as the Page 5 report source INSIDE an authenticated APEX session.
P3_FILE_LOB must already be a configured BLOB item, keyed by P3_PLAYER_ID.
Set Escape Special Characters = No for IMAGE only; keep other columns escaped.
The MIME-type allowlist avoids rendering arbitrary uploaded active content.

SELECT p.player_id, p.player_name, c.country_name,
       CASE WHEN NVL(DBMS_LOB.GETLENGTH(p.file_lob), 0) > 0
                  AND p.file_mimetype IN ('image/png', 'image/jpeg')
            THEN '<img alt="Player photo" src="'
                 || APEX_UTIL.GET_BLOB_FILE_SRC('P3_FILE_LOB', p.player_id)
                 || '" width="75" />'
       END AS image,
       p.file_name, p.file_mimetype, p.file_updatedate
FROM player_2025160093 p
LEFT JOIN country_2025160093 c ON c.country_code = p.country_code;

For country photos, use this Page 1 report query with P2_FILE_LOB configured:

SELECT c.country_code, c.country_name,
       CASE WHEN NVL(DBMS_LOB.GETLENGTH(c.file_lob), 0) > 0
                  AND c.file_mimetype IN ('image/png', 'image/jpeg')
            THEN '<img alt="Country image" src="'
                 || APEX_UTIL.GET_BLOB_FILE_SRC('P2_FILE_LOB', c.country_code)
                 || '" width="75" />'
       END AS image
FROM country_2025160093 c;
*/

-- Activity 11(i-iii): Manual's educational custom-user schema and seed record.
-- LAB DEMO ONLY: plaintext passwords and admin/admin123 follow the handout;
-- do not deploy this authentication design or these credentials publicly.
-- Production applications must use APEX Accounts, an identity provider, or a
-- reviewed salted adaptive password-hashing implementation instead.
-- USER_ROLE is an additional attribute for the required access-control page.
CREATE TABLE my_users_2025160093 (
    user_id NUMBER PRIMARY KEY,
    user_name VARCHAR2(20) NOT NULL,
    user_password VARCHAR2(20) NOT NULL,
    user_activated NUMBER(1) DEFAULT 0 NOT NULL CHECK (user_activated IN (0, 1)),
    user_role VARCHAR2(10) DEFAULT 'USER' NOT NULL CHECK (user_role IN ('ADMIN', 'USER'))
);

CREATE UNIQUE INDEX users_name_2025160093
ON my_users_2025160093 (UPPER(user_name));

CREATE SEQUENCE my_users_seq_2025160093 START WITH 30001 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER my_users_bi_2025160093
BEFORE INSERT ON my_users_2025160093
FOR EACH ROW
BEGIN
    IF :NEW.user_id IS NULL THEN
        SELECT my_users_seq_2025160093.NEXTVAL INTO :NEW.user_id FROM dual;
    END IF;
END;
/

INSERT INTO my_users_2025160093
    (user_id, user_name, user_password, user_activated, user_role)
VALUES(my_users_seq_2025160093.NEXTVAL, 'admin', 'admin123', 1, 'ADMIN');
COMMIT;

-- Activity 11(iv): Custom authentication function.
-- Unlike the handout's UPPER(password), comparison is case-sensitive.
CREATE OR REPLACE FUNCTION my_auth_2025160093 (
    p_username IN VARCHAR2,
    p_password IN VARCHAR2
) RETURN BOOLEAN
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM my_users_2025160093
    WHERE UPPER(user_name) = UPPER(p_username)
      AND user_password = p_password
      AND user_activated = 1;
    RETURN v_count = 1;
END;
/

-- Activity 11(v): Admin authorization, independent of login authentication.
CREATE OR REPLACE FUNCTION my_admin_2025160093 (
    p_username IN VARCHAR2
) RETURN BOOLEAN
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM my_users_2025160093
    WHERE UPPER(user_name) = UPPER(p_username)
      AND user_activated = 1 AND user_role = 'ADMIN';
    RETURN v_count = 1;
END;
/

/*
Shared Components > Authentication Schemes > Create > Custom:
  Authentication Function Name = my_auth_2025160093; make this scheme current.
  Keep the generated login page and its standard APEX login process.

Shared Components > Authorization Schemes > PL/SQL Function Returning Boolean:
  Name = LAB_ADMIN; evaluation = Always (No Caching).
  Function Body:
      RETURN my_admin_2025160093(V('APP_USER'));

Page 6: access-control report and form on MY_USERS_2025160093.
  Protect the PAGE, report/form regions, DML processes, buttons and navigation
  entries with LAB_ADMIN (hiding navigation alone is not access control).
  USER_ACTIVATED select list: Inactive;0, Active;1.
  USER_ROLE select list: User;USER, Administrator;ADMIN.
  USER_PASSWORD: Password item; never include it in a report.
  Restrict pages 1-5 to authenticated users as well.

Run the application and verify form/report/master-detail/file-upload behavior.
In App Builder use Export/Import > Export to obtain the application SQL export;
this file is schema/setup SQL, not a generated APEX application export.
*/

-- Access-control report source; deliberately omits passwords.
SELECT user_id, user_name, user_activated, user_role
FROM my_users_2025160093 ORDER BY user_name;

SELECT name, type, line, position, text FROM user_errors
WHERE name LIKE '%2025160093'
ORDER BY name, sequence;