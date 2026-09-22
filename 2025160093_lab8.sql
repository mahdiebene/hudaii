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

INSERT INTO country_2025160093 (country_name) VALUES('Bangladesh');
INSERT INTO country_2025160093 (country_name) VALUES('India');
INSERT INTO player_2025160093 (player_name, country_code)
SELECT 'Shakib Al Hasan', country_code FROM country_2025160093
WHERE country_name = 'Bangladesh';
INSERT INTO player_2025160093 (player_name, country_code)
SELECT 'Virat Kohli', country_code FROM country_2025160093
WHERE country_name = 'India';
COMMIT;

SELECT p.player_id, p.player_name, c.country_name,
       p.file_name, p.file_mimetype, p.file_updatedate
FROM player_2025160093 p
LEFT JOIN country_2025160093 c ON c.country_code = p.country_code
ORDER BY p.player_name;

SELECT country_code, country_name, file_name, file_mimetype, file_updatedate
FROM country_2025160093 ORDER BY country_name;

SELECT country_name AS display_value, country_code AS return_value
FROM country_2025160093 ORDER BY country_name;

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

SELECT user_id, user_name, user_activated, user_role
FROM my_users_2025160093 ORDER BY user_name;

SELECT name, type, line, position, text FROM user_errors
WHERE name LIKE '%2025160093'
ORDER BY name, sequence;
