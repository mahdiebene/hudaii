-- CSE302 Lab 1 | Student ID: 2025160093
-- Run once in a schema where these tables do not already exist.

-- Task 1(a): Instructor table.
CREATE TABLE instructor_2025160093 (
    id INT,
    name VARCHAR2(15),
    dept_name VARCHAR2(15),
    salary NUMBER(10, 2)
);

-- Task 2(a): Instructor records.
INSERT INTO instructor_2025160093 VALUES(10101, 'Srinivasan', 'Comp. Sci.', 65000);
INSERT INTO instructor_2025160093 VALUES(12121, 'Wu', 'Finance', 90000);
INSERT INTO instructor_2025160093 VALUES(15151, 'Mozart', 'Music', 40000);
INSERT INTO instructor_2025160093 VALUES(22222, 'Einstein', 'Physics', 95000);
INSERT INTO instructor_2025160093 VALUES(32343, 'El Said', 'History', 60000);
INSERT INTO instructor_2025160093 VALUES(33456, 'Gold', 'Physics', 87000);
INSERT INTO instructor_2025160093 VALUES(45565, 'Katz', 'Comp. Sci.', 75000);
INSERT INTO instructor_2025160093 VALUES(58583, 'Califieri', 'History', 62000);
INSERT INTO instructor_2025160093 VALUES(76543, 'Singh', 'Finance', 80000);
INSERT INTO instructor_2025160093 VALUES(76766, 'Crick', 'Biology', 72000);
INSERT INTO instructor_2025160093 VALUES(83821, 'Brandt', 'Comp. Sci.', 92000);
INSERT INTO instructor_2025160093 VALUES(98345, 'Kim', 'Elec. Eng.', 80000);

-- Task 1(b): Course table.
CREATE TABLE course_2025160093 (
    course_id VARCHAR2(10),
    title VARCHAR2(30),
    dept_name VARCHAR2(15),
    credits INT
);

-- Task 2(b): Course records.
INSERT INTO course_2025160093 VALUES('BIO-101', 'Intro. to Biology', 'Biology', 4);
INSERT INTO course_2025160093 VALUES('BIO-301', 'Genetics', 'Biology', 4);
INSERT INTO course_2025160093 VALUES('BIO-399', 'Computational Biology', 'Biology', 3);
INSERT INTO course_2025160093 VALUES('CS-101', 'Intro. to Computer Science', 'Comp. Sci.', 4);
INSERT INTO course_2025160093 VALUES('CS-190', 'Game Design', 'Comp. Sci.', 4);
INSERT INTO course_2025160093 VALUES('CS-315', 'Robotics', 'Comp. Sci.', 3);
INSERT INTO course_2025160093 VALUES('CS-319', 'Image Processing', 'Comp. Sci.', 3);
INSERT INTO course_2025160093 VALUES('CS-347', 'Database System Concepts', 'Comp. Sci.', 3);
INSERT INTO course_2025160093 VALUES('EE-181', 'Intro. to Digital Systems', 'Elec. Eng.', 3);
INSERT INTO course_2025160093 VALUES('FIN-201', 'Investment Banking', 'Finance', 3);
INSERT INTO course_2025160093 VALUES('HIS-351', 'World History', 'History', 3);
INSERT INTO course_2025160093 VALUES('MU-199', 'Music Video Production', 'Music', 3);
INSERT INTO course_2025160093 VALUES('PHY-101', 'Physical Principles', 'Physics', 4);

COMMIT;

-- Task 3(i): Instructor names.
SELECT name FROM instructor_2025160093;

-- Task 3(ii): Course IDs and titles.
SELECT course_id, title FROM course_2025160093;

-- Task 3(iii): Instructor 22222.
SELECT name, dept_name FROM instructor_2025160093 WHERE id = 22222;

-- Task 3(iv): Computer Science courses.
SELECT title, credits FROM course_2025160093 WHERE dept_name = 'Comp. Sci.';

-- Task 3(v): Salary greater than 70000.
SELECT name, dept_name FROM instructor_2025160093 WHERE salary > 70000;

-- Task 3(vi): At least four credits.
SELECT title FROM course_2025160093 WHERE credits >= 4;

-- Task 3(vii): Salary between 80000 and 100000, inclusive.
SELECT name, dept_name FROM instructor_2025160093
WHERE salary BETWEEN 80000 AND 100000;

-- Task 3(viii): Courses outside Computer Science.
SELECT title, credits FROM course_2025160093 WHERE dept_name <> 'Comp. Sci.';

-- Task 3(ix): All instructor records.
SELECT * FROM instructor_2025160093;

-- Task 3(x): Biology courses with credits other than four.
SELECT * FROM course_2025160093 WHERE dept_name = 'Biology' AND credits <> 4;