-- CSE302 Lab 5 | Student ID: 2025160093
-- Prerequisites: run Labs 1 and 3 once in the same schema.
-- The university handout section below creates its additional tables once.

-- OFFLINE PRACTICE: all ten banking problems, with both required variants.

-- 1(a). Account at a branch in the customer's city, without subqueries.
SELECT DISTINCT c.*
FROM bank_customer_2025160093 c
JOIN bank_depositor_2025160093 d ON d.customer_name = c.customer_name
JOIN bank_account_2025160093 a ON a.account_number = d.account_number
JOIN bank_branch_2025160093 b ON b.branch_name = a.branch_name
WHERE b.branch_city = c.customer_city;

-- 1(b). With a correlated subquery.
SELECT c.* FROM bank_customer_2025160093 c
WHERE EXISTS (
    SELECT 1 FROM bank_depositor_2025160093 d
    JOIN bank_account_2025160093 a ON a.account_number = d.account_number
    JOIN bank_branch_2025160093 b ON b.branch_name = a.branch_name
    WHERE d.customer_name = c.customer_name AND b.branch_city = c.customer_city
);

-- 2(a). Loan at a branch in the customer's city, without subqueries.
SELECT DISTINCT c.*
FROM bank_customer_2025160093 c
JOIN bank_borrower_2025160093 br ON br.customer_name = c.customer_name
JOIN bank_loan_2025160093 l ON l.loan_number = br.loan_number
JOIN bank_branch_2025160093 b ON b.branch_name = l.branch_name
WHERE b.branch_city = c.customer_city;

-- 2(b). With a correlated subquery.
SELECT c.* FROM bank_customer_2025160093 c
WHERE EXISTS (
    SELECT 1 FROM bank_borrower_2025160093 br
    JOIN bank_loan_2025160093 l ON l.loan_number = br.loan_number
    JOIN bank_branch_2025160093 b ON b.branch_name = l.branch_name
    WHERE br.customer_name = c.customer_name AND b.branch_city = c.customer_city
);

-- 3(a). City average balances; include cities whose total is at least 1000.
SELECT b.branch_city, AVG(a.balance) AS average_balance
FROM bank_branch_2025160093 b
JOIN bank_account_2025160093 a ON a.branch_name = b.branch_name
GROUP BY b.branch_city HAVING SUM(a.balance) >= 1000;

-- 3(b). Without HAVING.
SELECT branch_city, average_balance FROM (
    SELECT b.branch_city, AVG(a.balance) AS average_balance,
           SUM(a.balance) AS total_balance
    FROM bank_branch_2025160093 b
    JOIN bank_account_2025160093 a ON a.branch_name = b.branch_name
    GROUP BY b.branch_city
) WHERE total_balance >= 1000;

-- 4(a). City average loans of at least 1500, using HAVING.
SELECT b.branch_city, AVG(l.amount) AS average_amount
FROM bank_branch_2025160093 b
JOIN bank_loan_2025160093 l ON l.branch_name = b.branch_name
GROUP BY b.branch_city HAVING AVG(l.amount) >= 1500;

-- 4(b). Without HAVING.
SELECT branch_city, average_amount FROM (
    SELECT b.branch_city, AVG(l.amount) AS average_amount
    FROM bank_branch_2025160093 b
    JOIN bank_loan_2025160093 l ON l.branch_name = b.branch_name
    GROUP BY b.branch_city
) WHERE average_amount >= 1500;

-- 5(a). Customers of highest-balance accounts, using ALL; retain ties.
SELECT DISTINCT c.* FROM bank_customer_2025160093 c
JOIN bank_depositor_2025160093 d ON d.customer_name = c.customer_name
JOIN bank_account_2025160093 a ON a.account_number = d.account_number
WHERE a.balance >= ALL (SELECT balance FROM bank_account_2025160093);

-- 5(b). Without ALL.
SELECT DISTINCT c.* FROM bank_customer_2025160093 c
JOIN bank_depositor_2025160093 d ON d.customer_name = c.customer_name
JOIN bank_account_2025160093 a ON a.account_number = d.account_number
WHERE a.balance = (SELECT MAX(balance) FROM bank_account_2025160093);

-- 6(a). Customers of lowest-amount loans, using ALL; retain ties.
SELECT DISTINCT c.* FROM bank_customer_2025160093 c
JOIN bank_borrower_2025160093 b ON b.customer_name = c.customer_name
JOIN bank_loan_2025160093 l ON l.loan_number = b.loan_number
WHERE l.amount <= ALL (SELECT amount FROM bank_loan_2025160093);

-- 6(b). Without ALL.
SELECT DISTINCT c.* FROM bank_customer_2025160093 c
JOIN bank_borrower_2025160093 b ON b.customer_name = c.customer_name
JOIN bank_loan_2025160093 l ON l.loan_number = b.loan_number
WHERE l.amount = (SELECT MIN(amount) FROM bank_loan_2025160093);

-- 7(a). Branches with both accounts and loans, using IN.
SELECT branch_name, branch_city FROM bank_branch_2025160093
WHERE branch_name IN (SELECT branch_name FROM bank_account_2025160093)
  AND branch_name IN (SELECT branch_name FROM bank_loan_2025160093);

-- 7(b). Using EXISTS.
SELECT b.branch_name, b.branch_city FROM bank_branch_2025160093 b
WHERE EXISTS (SELECT 1 FROM bank_account_2025160093 a WHERE a.branch_name = b.branch_name)
  AND EXISTS (SELECT 1 FROM bank_loan_2025160093 l WHERE l.branch_name = b.branch_name);

-- 8(a). Account holders without loans, using NOT IN.
-- Both subquery customer_name columns are non-null primary-key components.
SELECT customer_name, customer_city FROM bank_customer_2025160093
WHERE customer_name IN (SELECT customer_name FROM bank_depositor_2025160093)
  AND customer_name NOT IN (SELECT customer_name FROM bank_borrower_2025160093);

-- 8(b). Using NOT EXISTS.
SELECT c.customer_name, c.customer_city FROM bank_customer_2025160093 c
WHERE EXISTS (SELECT 1 FROM bank_depositor_2025160093 d WHERE d.customer_name = c.customer_name)
  AND NOT EXISTS (SELECT 1 FROM bank_borrower_2025160093 b WHERE b.customer_name = c.customer_name);

-- 9(a). Above-average branch total balance, using WITH.
-- "All branches" includes branches without accounts (total zero).
WITH branch_totals AS (
    SELECT b.branch_name, NVL(SUM(a.balance), 0) AS total_balance
    FROM bank_branch_2025160093 b
    LEFT JOIN bank_account_2025160093 a ON a.branch_name = b.branch_name
    GROUP BY b.branch_name
)
SELECT branch_name FROM branch_totals
WHERE total_balance > (SELECT AVG(total_balance) FROM branch_totals);

-- 9(b). Without WITH.
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

-- 10(a). Below-average branch total loans, using WITH; zero-loan branches count.
WITH branch_totals AS (
    SELECT b.branch_name, NVL(SUM(l.amount), 0) AS total_amount
    FROM bank_branch_2025160093 b
    LEFT JOIN bank_loan_2025160093 l ON l.branch_name = b.branch_name
    GROUP BY b.branch_name
)
SELECT branch_name FROM branch_totals
WHERE total_amount < (SELECT AVG(total_amount) FROM branch_totals);

-- 10(b). Without WITH.
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

-- UNIVERSITY HANDOUT: supporting relations for the Lab 1 university tables.
-- Standard small university dataset, using the handout's 2009/2010 years.
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

-- A1. Courses offered in Fall 2009 and Spring 2010, using IN.
SELECT DISTINCT course_id FROM section_2025160093
WHERE semester = 'Fall' AND year = 2009
  AND course_id IN (
      SELECT course_id FROM section_2025160093
      WHERE semester = 'Spring' AND year = 2010
  );

-- A2. Fall 2009 courses not offered in Spring 2010, using NOT IN.
SELECT DISTINCT course_id FROM section_2025160093
WHERE semester = 'Fall' AND year = 2009
  AND course_id NOT IN (
      SELECT course_id FROM section_2025160093
      WHERE semester = 'Spring' AND year = 2010
  );

-- A3. Distinct students taught by instructor 10101; match the whole section key.
SELECT COUNT(DISTINCT id) AS student_count FROM takes_2025160093
WHERE (course_id, sec_id, semester, year) IN (
    SELECT course_id, sec_id, semester, year FROM teaches_2025160093
    WHERE id = 10101
);

-- B1. Salary greater than at least one Biology instructor.
SELECT name FROM instructor_2025160093
WHERE salary > SOME (
    SELECT salary FROM instructor_2025160093 WHERE dept_name = 'Biology'
);

-- B2. Salary greater than every Biology instructor.
SELECT name FROM instructor_2025160093
WHERE salary > ALL (
    SELECT salary FROM instructor_2025160093 WHERE dept_name = 'Biology'
);

-- C1. Courses in both semesters, using EXISTS.
SELECT DISTINCT s.course_id FROM section_2025160093 s
WHERE s.semester = 'Fall' AND s.year = 2009
  AND EXISTS (
      SELECT 1 FROM section_2025160093 t
      WHERE t.course_id = s.course_id AND t.semester = 'Spring' AND t.year = 2010
  );

-- C2. Fall courses absent in Spring, using NOT EXISTS.
SELECT DISTINCT s.course_id FROM section_2025160093 s
WHERE s.semester = 'Fall' AND s.year = 2009
  AND NOT EXISTS (
      SELECT 1 FROM section_2025160093 t
      WHERE t.course_id = s.course_id AND t.semester = 'Spring' AND t.year = 2010
  );

-- C3. Students who have taken every Biology course (relational division).
SELECT s.* FROM uni_student_2025160093 s
WHERE NOT EXISTS (
    SELECT 1 FROM course_2025160093 c
    WHERE c.dept_name = 'Biology'
      AND NOT EXISTS (
          SELECT 1 FROM takes_2025160093 t
          WHERE t.id = s.id AND t.course_id = c.course_id
      )
);

-- FROM subquery: department average salaries above 42000.
SELECT dept_name, average_salary FROM (
    SELECT dept_name, AVG(salary) AS average_salary
    FROM instructor_2025160093 GROUP BY dept_name
) WHERE average_salary > 42000;

-- WITH: departments with the maximum budget, including ties.
WITH maximum_budget AS (
    SELECT MAX(budget) AS budget FROM department_2025160093
)
SELECT d.* FROM department_2025160093 d
JOIN maximum_budget m ON m.budget = d.budget;

-- WITH: total salary above the average departmental total (include zero totals).
WITH salary_totals AS (
    SELECT d.dept_name, NVL(SUM(i.salary), 0) AS total_salary
    FROM department_2025160093 d
    LEFT JOIN instructor_2025160093 i ON i.dept_name = d.dept_name
    GROUP BY d.dept_name
)
SELECT dept_name, total_salary FROM salary_totals
WHERE total_salary > (SELECT AVG(total_salary) FROM salary_totals);

-- Scalar SELECT subquery: instructor count per department, including zero.
SELECT d.dept_name,
       (SELECT COUNT(*) FROM instructor_2025160093 i
        WHERE i.dept_name = d.dept_name) AS instructor_count
FROM department_2025160093 d;

-- LEFT OUTER JOIN: instructor count including departments without instructors.
SELECT d.dept_name, COUNT(i.id) AS instructor_count
FROM department_2025160093 d
LEFT OUTER JOIN instructor_2025160093 i ON i.dept_name = d.dept_name
GROUP BY d.dept_name;

-- RIGHT OUTER JOIN: equivalent department-preserving result.
SELECT d.dept_name, COUNT(i.id) AS instructor_count
FROM instructor_2025160093 i
RIGHT OUTER JOIN department_2025160093 d ON d.dept_name = i.dept_name
GROUP BY d.dept_name;

-- FULL OUTER JOIN: preserve unmatched rows on either side.
SELECT NVL(d.dept_name, i.dept_name) AS dept_name, i.id, i.name
FROM department_2025160093 d
FULL OUTER JOIN instructor_2025160093 i ON i.dept_name = d.dept_name;