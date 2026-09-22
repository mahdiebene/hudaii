-- CSE302 Lab 4 | Student ID: 2025160093
-- Prerequisite: run 2025160093_lab1.sql once.
-- The manual names no individual HackerRank problems. Its assessed tasks are
-- creating a HackerRank account and practising SQL there; those are web tasks.
-- The following statements cover every built-in function in the handout.

-- String functions.
SELECT ASCII('t') AS ascii_value FROM dual;
SELECT CHR(116) AS character_value FROM dual;
SELECT CONCAT('Tech on', ' the Net') AS concatenated FROM dual;
SELECT 'a' || 'b' || 'c' || 'd' AS concatenated FROM dual;
SELECT INITCAP('tech on the net') AS title_case FROM dual;
SELECT INSTR('Tech on the net', 'e') AS first_position FROM dual;
SELECT LENGTH('Tech on the Net') AS string_length FROM dual;
SELECT LOWER('Tech on the Net') AS lower_case FROM dual;
SELECT UPPER('Tech on the Net') AS upper_case FROM dual;
SELECT LPAD('tech', 8, '0') AS left_padded FROM dual;
SELECT RPAD('tech', 8, '0') AS right_padded FROM dual;
SELECT LTRIM('xyxzyyyTech', 'xyz') AS left_trimmed FROM dual;
SELECT RTRIM('Techxyxzyyy', 'xyz') AS right_trimmed FROM dual;
SELECT REPLACE('222tech', '2', '3') AS replaced FROM dual;
SELECT SUBSTR('TechOnTheNet', 1, 4) AS substring_value FROM dual;

-- Numeric functions.
SELECT ABS(-23) AS absolute_value FROM dual;
SELECT BITAND(5, 3) AS bitwise_and FROM dual;
SELECT CEIL(32.65) AS ceiling_value FROM dual;
SELECT FLOOR(5.9) AS floor_value FROM dual;
SELECT GREATEST(2, 5, 12, 3) AS greatest_value FROM dual;
SELECT LEAST(2, 5, 12, 3) AS least_value FROM dual;
SELECT LOG(2, 15) AS logarithm FROM dual;
SELECT MEDIAN(salary) AS median_salary FROM instructor_2025160093;
SELECT dept_name, MEDIAN(salary) AS median_salary
FROM instructor_2025160093 GROUP BY dept_name;
SELECT MOD(11.6, 2) AS remainder FROM dual;
SELECT POWER(3, 2) AS power_value FROM dual;
SELECT SQRT(5.617) AS square_root FROM dual;
SELECT ROUND(125.315, 2) AS rounded FROM dual;
SELECT TRUNC(125.815, 2) AS truncated FROM dual;
SELECT id, name, ROUND(salary, 2) AS salary FROM instructor_2025160093;

-- ROWNUM: sort inside the subquery before assigning row numbers.
SELECT ROWNUM AS row_number, i.*
FROM (SELECT * FROM instructor_2025160093 ORDER BY id) i;

-- Date functions: explicit date literals avoid session-format dependencies.
SELECT ADD_MONTHS(DATE '2003-08-21', -3) AS three_months_earlier FROM dual;
SELECT EXTRACT(YEAR FROM DATE '2003-08-22') AS year_value FROM dual;
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD') AS formatted_today FROM dual;
SELECT TO_DATE('2015/05/15 8:30:25', 'YYYY/MM/DD HH24:MI:SS') AS converted_date
FROM dual;