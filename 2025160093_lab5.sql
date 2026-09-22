SELECT DISTINCT c.*
FROM bank_customer_2025160093 c
JOIN bank_depositor_2025160093 d ON d.customer_name = c.customer_name
JOIN bank_account_2025160093 a ON a.account_number = d.account_number
JOIN bank_branch_2025160093 b ON b.branch_name = a.branch_name
WHERE b.branch_city = c.customer_city;

SELECT c.* FROM bank_customer_2025160093 c
WHERE EXISTS (
    SELECT 1 FROM bank_depositor_2025160093 d
    JOIN bank_account_2025160093 a ON a.account_number = d.account_number
    JOIN bank_branch_2025160093 b ON b.branch_name = a.branch_name
    WHERE d.customer_name = c.customer_name AND b.branch_city = c.customer_city
);

SELECT DISTINCT c.*
FROM bank_customer_2025160093 c
JOIN bank_borrower_2025160093 br ON br.customer_name = c.customer_name
JOIN bank_loan_2025160093 l ON l.loan_number = br.loan_number
JOIN bank_branch_2025160093 b ON b.branch_name = l.branch_name
WHERE b.branch_city = c.customer_city;

SELECT c.* FROM bank_customer_2025160093 c
WHERE EXISTS (
    SELECT 1 FROM bank_borrower_2025160093 br
    JOIN bank_loan_2025160093 l ON l.loan_number = br.loan_number
    JOIN bank_branch_2025160093 b ON b.branch_name = l.branch_name
    WHERE br.customer_name = c.customer_name AND b.branch_city = c.customer_city
);

SELECT b.branch_city, AVG(a.balance) AS average_balance
FROM bank_branch_2025160093 b
JOIN bank_account_2025160093 a ON a.branch_name = b.branch_name
GROUP BY b.branch_city HAVING SUM(a.balance) >= 1000;

SELECT branch_city, average_balance FROM (
    SELECT b.branch_city, AVG(a.balance) AS average_balance,
           SUM(a.balance) AS total_balance
    FROM bank_branch_2025160093 b
    JOIN bank_account_2025160093 a ON a.branch_name = b.branch_name
    GROUP BY b.branch_city
) WHERE total_balance >= 1000;

SELECT b.branch_city, AVG(l.amount) AS average_amount
FROM bank_branch_2025160093 b
JOIN bank_loan_2025160093 l ON l.branch_name = b.branch_name
GROUP BY b.branch_city HAVING AVG(l.amount) >= 1500;

SELECT branch_city, average_amount FROM (
    SELECT b.branch_city, AVG(l.amount) AS average_amount
    FROM bank_branch_2025160093 b
    JOIN bank_loan_2025160093 l ON l.branch_name = b.branch_name
    GROUP BY b.branch_city
) WHERE average_amount >= 1500;

SELECT DISTINCT c.* FROM bank_customer_2025160093 c
JOIN bank_depositor_2025160093 d ON d.customer_name = c.customer_name
JOIN bank_account_2025160093 a ON a.account_number = d.account_number
WHERE a.balance >= ALL (SELECT balance FROM bank_account_2025160093);

SELECT DISTINCT c.* FROM bank_customer_2025160093 c
JOIN bank_depositor_2025160093 d ON d.customer_name = c.customer_name
JOIN bank_account_2025160093 a ON a.account_number = d.account_number
WHERE a.balance = (SELECT MAX(balance) FROM bank_account_2025160093);

SELECT DISTINCT c.* FROM bank_customer_2025160093 c
JOIN bank_borrower_2025160093 b ON b.customer_name = c.customer_name
JOIN bank_loan_2025160093 l ON l.loan_number = b.loan_number
WHERE l.amount <= ALL (SELECT amount FROM bank_loan_2025160093);

SELECT DISTINCT c.* FROM bank_customer_2025160093 c
JOIN bank_borrower_2025160093 b ON b.customer_name = c.customer_name
JOIN bank_loan_2025160093 l ON l.loan_number = b.loan_number
WHERE l.amount = (SELECT MIN(amount) FROM bank_loan_2025160093);

SELECT branch_name, branch_city FROM bank_branch_2025160093
WHERE branch_name IN (SELECT branch_name FROM bank_account_2025160093)
  AND branch_name IN (SELECT branch_name FROM bank_loan_2025160093);

SELECT b.branch_name, b.branch_city FROM bank_branch_2025160093 b
WHERE EXISTS (SELECT 1 FROM bank_account_2025160093 a WHERE a.branch_name = b.branch_name)
  AND EXISTS (SELECT 1 FROM bank_loan_2025160093 l WHERE l.branch_name = b.branch_name);

SELECT customer_name, customer_city FROM bank_customer_2025160093
WHERE customer_name IN (SELECT customer_name FROM bank_depositor_2025160093)
  AND customer_name NOT IN (SELECT customer_name FROM bank_borrower_2025160093);

SELECT c.customer_name, c.customer_city FROM bank_customer_2025160093 c
WHERE EXISTS (SELECT 1 FROM bank_depositor_2025160093 d WHERE d.customer_name = c.customer_name)
  AND NOT EXISTS (SELECT 1 FROM bank_borrower_2025160093 b WHERE b.customer_name = c.customer_name);

WITH branch_totals AS (
    SELECT b.branch_name, NVL(SUM(a.balance), 0) AS total_balance
    FROM bank_branch_2025160093 b
    LEFT JOIN bank_account_2025160093 a ON a.branch_name = b.branch_name
    GROUP BY b.branch_name
)
SELECT branch_name FROM branch_totals
WHERE total_balance > (SELECT AVG(total_balance) FROM branch_totals);

SELECT b.branch_name FROM bank_branch_2025160093 b
LEFT JOIN bank_account_2025160093 a ON a.branch_name = b.branch_name
GROUP BY b.branch_name
HAVING NVL(SUM(a.balance), 0) > (
    SELECT AVG(total_balance) FROM (
        SELECT NVL(SUM(a2.balance), 0) AS total_balance
        FROM bank_branch_2025160093 b2
        LEFT JOIN bank_account_2025160093 a2 ON a2.branch_name = b2.branch_name
        GROUP BY b2.branch_name
    )
);

WITH branch_totals AS (
    SELECT b.branch_name, NVL(SUM(l.amount), 0) AS total_amount
    FROM bank_branch_2025160093 b
    LEFT JOIN bank_loan_2025160093 l ON l.branch_name = b.branch_name
    GROUP BY b.branch_name
)
SELECT branch_name FROM branch_totals
WHERE total_amount < (SELECT AVG(total_amount) FROM branch_totals);

SELECT b.branch_name FROM bank_branch_2025160093 b
LEFT JOIN bank_loan_2025160093 l ON l.branch_name = b.branch_name
GROUP BY b.branch_name
HAVING NVL(SUM(l.amount), 0) < (
    SELECT AVG(total_amount) FROM (
        SELECT NVL(SUM(l2.amount), 0) AS total_amount
        FROM bank_branch_2025160093 b2
        LEFT JOIN bank_loan_2025160093 l2 ON l2.branch_name = b2.branch_name
        GROUP BY b2.branch_name
    )
);

CREATE TABLE department_2025160093 (
    dept_name VARCHAR2(15) PRIMARY KEY,
    building VARCHAR2(15),
    budget NUMBER(12, 2)
);
CREATE TABLE uni_student_2025160093 (
    id VARCHAR2(5) PRIMARY KEY,
    name VARCHAR2(20) NOT NULL,
    dept_name VARCHAR2(15) REFERENCES department_2025160093(dept_name),
    tot_cred NUMBER(3)
);
CREATE TABLE section_2025160093 (
    course_id VARCHAR2(10),
    sec_id VARCHAR2(8),
    semester VARCHAR2(6),
    year NUMBER(4),
    PRIMARY KEY (course_id, sec_id, semester, year)
);
CREATE TABLE teaches_2025160093 (
    id INT,
    course_id VARCHAR2(10),
    sec_id VARCHAR2(8),
    semester VARCHAR2(6),
    year NUMBER(4),
    PRIMARY KEY (id, course_id, sec_id, semester, year),
    FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section_2025160093(course_id, sec_id, semester, year)
);
CREATE TABLE takes_2025160093 (
    id VARCHAR2(5) REFERENCES uni_student_2025160093(id),
    course_id VARCHAR2(10),
    sec_id VARCHAR2(8),
    semester VARCHAR2(6),
    year NUMBER(4),
    grade VARCHAR2(2),
    PRIMARY KEY (id, course_id, sec_id, semester, year),
    FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section_2025160093(course_id, sec_id, semester, year)
);

INSERT INTO department_2025160093 VALUES('Biology', 'Watson', 90000);
INSERT INTO department_2025160093 VALUES('Comp. Sci.', 'Taylor', 100000);
INSERT INTO department_2025160093 VALUES('Elec. Eng.', 'Taylor', 85000);
INSERT INTO department_2025160093 VALUES('Finance', 'Painter', 120000);
INSERT INTO department_2025160093 VALUES('History', 'Painter', 50000);
INSERT INTO department_2025160093 VALUES('Music', 'Packard', 80000);
INSERT INTO department_2025160093 VALUES('Physics', 'Watson', 70000);

INSERT INTO uni_student_2025160093 VALUES('00128', 'Zhang', 'Comp. Sci.', 102);
INSERT INTO uni_student_2025160093 VALUES('12345', 'Shankar', 'Comp. Sci.', 32);
INSERT INTO uni_student_2025160093 VALUES('19991', 'Brandt', 'History', 80);
INSERT INTO uni_student_2025160093 VALUES('23121', 'Chavez', 'Finance', 110);
INSERT INTO uni_student_2025160093 VALUES('44553', 'Peltier', 'Physics', 56);
INSERT INTO uni_student_2025160093 VALUES('45678', 'Levy', 'Physics', 46);
INSERT INTO uni_student_2025160093 VALUES('54321', 'Williams', 'Comp. Sci.', 54);
INSERT INTO uni_student_2025160093 VALUES('55739', 'Sanchez', 'Music', 38);
INSERT INTO uni_student_2025160093 VALUES('70557', 'Snow', 'Physics', 0);
INSERT INTO uni_student_2025160093 VALUES('76543', 'Brown', 'Comp. Sci.', 58);
INSERT INTO uni_student_2025160093 VALUES('76653', 'Aoi', 'Elec. Eng.', 60);
INSERT INTO uni_student_2025160093 VALUES('98765', 'Bourikas', 'Comp. Sci.', 98);
INSERT INTO uni_student_2025160093 VALUES('98988', 'Tanaka', 'Biology', 120);

INSERT INTO section_2025160093 VALUES('BIO-101', '1', 'Summer', 2009);
INSERT INTO section_2025160093 VALUES('BIO-301', '1', 'Summer', 2010);
INSERT INTO section_2025160093 VALUES('CS-101', '1', 'Fall', 2009);
INSERT INTO section_2025160093 VALUES('CS-101', '1', 'Spring', 2010);
INSERT INTO section_2025160093 VALUES('CS-190', '1', 'Spring', 2009);
INSERT INTO section_2025160093 VALUES('CS-190', '2', 'Spring', 2009);
INSERT INTO section_2025160093 VALUES('CS-315', '1', 'Spring', 2010);
INSERT INTO section_2025160093 VALUES('CS-319', '1', 'Spring', 2010);
INSERT INTO section_2025160093 VALUES('CS-319', '2', 'Spring', 2010);
INSERT INTO section_2025160093 VALUES('CS-347', '1', 'Fall', 2009);
INSERT INTO section_2025160093 VALUES('EE-181', '1', 'Spring', 2009);
INSERT INTO section_2025160093 VALUES('FIN-201', '1', 'Spring', 2010);
INSERT INTO section_2025160093 VALUES('HIS-351', '1', 'Spring', 2010);
INSERT INTO section_2025160093 VALUES('MU-199', '1', 'Spring', 2010);
INSERT INTO section_2025160093 VALUES('PHY-101', '1', 'Fall', 2009);

INSERT INTO teaches_2025160093 VALUES(10101, 'CS-101', '1', 'Fall', 2009);
INSERT INTO teaches_2025160093 VALUES(10101, 'CS-315', '1', 'Spring', 2010);
INSERT INTO teaches_2025160093 VALUES(10101, 'CS-347', '1', 'Fall', 2009);
INSERT INTO teaches_2025160093 VALUES(12121, 'FIN-201', '1', 'Spring', 2010);
INSERT INTO teaches_2025160093 VALUES(15151, 'MU-199', '1', 'Spring', 2010);
INSERT INTO teaches_2025160093 VALUES(22222, 'PHY-101', '1', 'Fall', 2009);
INSERT INTO teaches_2025160093 VALUES(32343, 'HIS-351', '1', 'Spring', 2010);
INSERT INTO teaches_2025160093 VALUES(45565, 'CS-101', '1', 'Spring', 2010);
INSERT INTO teaches_2025160093 VALUES(45565, 'CS-319', '1', 'Spring', 2010);
INSERT INTO teaches_2025160093 VALUES(76766, 'BIO-101', '1', 'Summer', 2009);
INSERT INTO teaches_2025160093 VALUES(76766, 'BIO-301', '1', 'Summer', 2010);
INSERT INTO teaches_2025160093 VALUES(83821, 'CS-190', '1', 'Spring', 2009);
INSERT INTO teaches_2025160093 VALUES(83821, 'CS-190', '2', 'Spring', 2009);
INSERT INTO teaches_2025160093 VALUES(83821, 'CS-319', '2', 'Spring', 2010);
INSERT INTO teaches_2025160093 VALUES(98345, 'EE-181', '1', 'Spring', 2009);

INSERT INTO takes_2025160093 VALUES('00128', 'CS-101', '1', 'Fall', 2009, 'A');
INSERT INTO takes_2025160093 VALUES('00128', 'CS-347', '1', 'Fall', 2009, 'A-');
INSERT INTO takes_2025160093 VALUES('12345', 'CS-101', '1', 'Fall', 2009, 'C');
INSERT INTO takes_2025160093 VALUES('12345', 'CS-190', '2', 'Spring', 2009, 'A');
INSERT INTO takes_2025160093 VALUES('12345', 'CS-315', '1', 'Spring', 2010, 'A');
INSERT INTO takes_2025160093 VALUES('12345', 'CS-347', '1', 'Fall', 2009, 'A');
INSERT INTO takes_2025160093 VALUES('19991', 'HIS-351', '1', 'Spring', 2010, 'B');
INSERT INTO takes_2025160093 VALUES('23121', 'FIN-201', '1', 'Spring', 2010, 'C+');
INSERT INTO takes_2025160093 VALUES('44553', 'PHY-101', '1', 'Fall', 2009, 'B-');
INSERT INTO takes_2025160093 VALUES('45678', 'CS-101', '1', 'Fall', 2009, 'F');
INSERT INTO takes_2025160093 VALUES('45678', 'CS-101', '1', 'Spring', 2010, 'B+');
INSERT INTO takes_2025160093 VALUES('45678', 'CS-319', '1', 'Spring', 2010, 'B');
INSERT INTO takes_2025160093 VALUES('54321', 'CS-101', '1', 'Fall', 2009, 'A-');
INSERT INTO takes_2025160093 VALUES('54321', 'CS-190', '2', 'Spring', 2009, 'B+');
INSERT INTO takes_2025160093 VALUES('55739', 'MU-199', '1', 'Spring', 2010, 'A-');
INSERT INTO takes_2025160093 VALUES('76543', 'CS-101', '1', 'Fall', 2009, 'A');
INSERT INTO takes_2025160093 VALUES('76543', 'CS-319', '2', 'Spring', 2010, 'A');
INSERT INTO takes_2025160093 VALUES('76653', 'EE-181', '1', 'Spring', 2009, 'C');
INSERT INTO takes_2025160093 VALUES('98765', 'CS-101', '1', 'Fall', 2009, 'C-');
INSERT INTO takes_2025160093 VALUES('98765', 'CS-315', '1', 'Spring', 2010, 'B');
INSERT INTO takes_2025160093 VALUES('98988', 'BIO-101', '1', 'Summer', 2009, 'A');
INSERT INTO takes_2025160093 VALUES('98988', 'BIO-301', '1', 'Summer', 2010, NULL);
COMMIT;

SELECT DISTINCT course_id FROM section_2025160093
WHERE semester = 'Fall' AND year = 2009
  AND course_id IN (
      SELECT course_id FROM section_2025160093
      WHERE semester = 'Spring' AND year = 2010
  );

SELECT DISTINCT course_id FROM section_2025160093
WHERE semester = 'Fall' AND year = 2009
  AND course_id NOT IN (
      SELECT course_id FROM section_2025160093
      WHERE semester = 'Spring' AND year = 2010
  );

SELECT COUNT(DISTINCT id) AS student_count FROM takes_2025160093
WHERE (course_id, sec_id, semester, year) IN (
    SELECT course_id, sec_id, semester, year FROM teaches_2025160093
    WHERE id = 10101
);

SELECT name FROM instructor_2025160093
WHERE salary > SOME (
    SELECT salary FROM instructor_2025160093 WHERE dept_name = 'Biology'
);

SELECT name FROM instructor_2025160093
WHERE salary > ALL (
    SELECT salary FROM instructor_2025160093 WHERE dept_name = 'Biology'
);

SELECT DISTINCT s.course_id FROM section_2025160093 s
WHERE s.semester = 'Fall' AND s.year = 2009
  AND EXISTS (
      SELECT 1 FROM section_2025160093 t
      WHERE t.course_id = s.course_id AND t.semester = 'Spring' AND t.year = 2010
  );

SELECT DISTINCT s.course_id FROM section_2025160093 s
WHERE s.semester = 'Fall' AND s.year = 2009
  AND NOT EXISTS (
      SELECT 1 FROM section_2025160093 t
      WHERE t.course_id = s.course_id AND t.semester = 'Spring' AND t.year = 2010
  );

SELECT s.* FROM uni_student_2025160093 s
WHERE NOT EXISTS (
    SELECT 1 FROM course_2025160093 c
    WHERE c.dept_name = 'Biology'
      AND NOT EXISTS (
          SELECT 1 FROM takes_2025160093 t
          WHERE t.id = s.id AND t.course_id = c.course_id
      )
);

SELECT dept_name, average_salary FROM (
    SELECT dept_name, AVG(salary) AS average_salary
    FROM instructor_2025160093 GROUP BY dept_name
) WHERE average_salary > 42000;

WITH maximum_budget AS (
    SELECT MAX(budget) AS budget FROM department_2025160093
)
SELECT d.* FROM department_2025160093 d
JOIN maximum_budget m ON m.budget = d.budget;

WITH salary_totals AS (
    SELECT d.dept_name, NVL(SUM(i.salary), 0) AS total_salary
    FROM department_2025160093 d
    LEFT JOIN instructor_2025160093 i ON i.dept_name = d.dept_name
    GROUP BY d.dept_name
)
SELECT dept_name, total_salary FROM salary_totals
WHERE total_salary > (SELECT AVG(total_salary) FROM salary_totals);

SELECT d.dept_name,
       (SELECT COUNT(*) FROM instructor_2025160093 i
        WHERE i.dept_name = d.dept_name) AS instructor_count
FROM department_2025160093 d;

SELECT d.dept_name, COUNT(i.id) AS instructor_count
FROM department_2025160093 d
LEFT OUTER JOIN instructor_2025160093 i ON i.dept_name = d.dept_name
GROUP BY d.dept_name;

SELECT d.dept_name, COUNT(i.id) AS instructor_count
FROM instructor_2025160093 i
RIGHT OUTER JOIN department_2025160093 d ON d.dept_name = i.dept_name
GROUP BY d.dept_name;

SELECT NVL(d.dept_name, i.dept_name) AS dept_name, i.id, i.name
FROM department_2025160093 d
FULL OUTER JOIN instructor_2025160093 i ON i.dept_name = d.dept_name;
