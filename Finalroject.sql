CREATE DATABASE FinalProject;
USE FinalProject;

CREATE TABLE Students(
StudentID INT PRIMARY KEY,
FirstName VARCHAR(100) NOT NULL,
LastName VARCHAR(100),
Email VARCHAR(100),
BirthDate DATE,
EnrollmentDate DATE
);

CREATE TABLE Department(
DepartmentID INT PRIMARY KEY,
DepartName VARCHAR(100)
);

CREATE TABLE Courses(
CourseID INT PRIMARY KEY,
CourseName VARCHAR(100),
DepartmentID INT,
Credits INT,
FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
 );
 
 CREATE TABLE Instructor(
 InstructorID INT PRIMARY KEY,
 FirstName VARCHAR(100) NOT NULL,
 LastName VARCHAR(100),
 Email VARCHAR(100),
 DepartmentID INT,
FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

CREATE TABLE Enrollment(
EnrollmentID INT PRIMARY KEY,
StudentID INT,
CourseID INT,
EnrollmentDate DATE,
FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Students (StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate) 
VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2000-01-15', '2022-08-01'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '1999-05-25', '2021-08-01'),
(3, 'Riya', 'Patel', 'riya@email.com', '2001-03-12', '2023-07-01'),
(4, 'Amit', 'Shah', 'amit@email.com', '2000-09-10', '2022-06-15'),
(5, 'Neha', 'Verma', 'neha@email.com', '2002-11-20', '2023-01-10'),
(6, 'Rahul', 'Mehta', 'rahul@email.com', '1998-12-01', '2020-08-01'),
(7, 'Priya', 'Singh', 'priya@email.com', '2001-07-18', '2022-09-01'),
(8, 'Karan', 'Patel', 'karan@email.com', '2000-04-22', '2021-07-01'),
(9, 'Sneha', 'Joshi', 'sneha@email.com', '2001-02-14', '2022-08-15'),
(10, 'Vikas', 'Yadav', 'vikas@email.com', '1999-10-05', '2020-07-10'),
(11, 'Pooja', 'Sharma', 'pooja@email.com', '2002-05-19', '2023-06-01'),
(12, 'Arjun', 'Kapoor', 'arjun@email.com', '2001-08-22', '2022-07-20'),
(13, 'Meena', 'Iyer', 'meena@email.com', '2000-11-11', '2021-08-01'),
(14, 'Rohit', 'Das', 'rohit@email.com', '1998-03-03', '2019-08-01');

INSERT INTO Department(DepartmentID, DepartName)
VALUES
(1, 'Computer Science'),
(2, 'Electrical'),
(3, 'Electronics'),
(4, 'Mechanical');

INSERT INTO Courses (CourseID, CourseName, DepartmentID, Credits)
VALUES
(101, 'Introduction to SQL', 1, 3),
(102, 'Data Structures', 2, 4),
(103, 'Operating Systems', 1, 4),
(104, 'Algorithms', 1, 4),
(105, 'Linear Algebra', 2, 3),
(106, 'Calculus', 2, 3);

INSERT INTO Instructor (InstructorID, FirstName, LastName, Email, DepartmentID)
VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@univ.com', 1),
(2, 'Bob', 'Lee', 'bob.lee@univ.com', 2),
(3, 'David', 'Miller', 'david@univ.com', 1),
(4, 'Sara', 'Wilson', 'sara@univ.com', 2);

INSERT INTO Enrollment (EnrollmentID, StudentID, CourseID, EnrollmentDate)
VALUES
(1, 1, 101, '2022-08-01'),
(2, 2, 102, '2021-08-01'),
(3, 3, 101, '2023-07-01'),
(4, 4, 101, '2022-06-15'),
(5, 5, 101, '2023-01-10'),
(6, 6, 101, '2020-08-01'),
(7, 7, 101, '2022-09-01'),
(8, 8, 101, '2021-07-01'),
(9, 3, 102, '2023-07-01'),
(10, 4, 102, '2022-06-15'),
(11, 5, 102, '2023-01-10'),
(12, 3, 103, '2023-07-01'),
(13, 4, 103, '2022-06-15'),
(14, 5, 103, '2023-01-10'),
(15, 6, 103, '2020-08-01'),
(16, 7, 103, '2022-09-01'),
(17, 8, 103, '2021-07-01'),
(18, 9, 103, '2022-08-15'),
(19, 10, 103, '2020-07-10'),
(20, 11, 103, '2023-06-01'),
(21, 12, 103, '2022-07-20'),
(22, 13, 103, '2021-08-01');

-- 1.
SELECT * FROM Students;
SELECT * FROM Department;
SELECT * FROM Courses;
SELECT * FROM Enrollment;
SELECT * FROM Instructor;

UPDATE Department
SET DepartName  = 'Mathematics'
WHERE DepartName = 'Electrical';

-- DELETE FROM Students WHERE StudentID = 14;

-- 2.
SELECT * FROM Students
WHERE EnrollmentDate > '2022-12-31';

-- 3.
SELECT * FROM Courses c
JOIN Department d ON c.DepartmentID = d.DepartmentID
WHERE d.DepartName = 'Mathematics'
LIMIT 5;

-- 4.
SELECT CourseID, COUNT(StudentID) AS TotalStudents
FROM Enrollment
GROUP BY CourseID
HAVING COUNT(StudentID) > 5;

-- 5.
SELECT s.*
FROM Students s
JOIN Enrollment e1 
ON s.StudentID = e1.StudentID AND e1.CourseID = 101
JOIN Enrollment e2 
ON s.StudentID = e2.StudentID AND e2.CourseID = 102;

-- 6.
SELECT DISTINCT s.*
FROM Students s
JOIN Enrollment e 
ON s.StudentID = e.StudentID
WHERE e.CourseID IN (101, 102);

-- 7. 
SELECT AVG(Credits) AS AvgCredits
FROM Courses;

-- 8. 

ALTER TABLE Instructor
ADD Salary INT;

UPDATE Instructor SET Salary = 50000 WHERE InstructorID = 1;
UPDATE Instructor SET Salary = 60000 WHERE InstructorID = 2;
UPDATE Instructor SET Salary = 55000 WHERE InstructorID = 3;
UPDATE Instructor SET Salary = 65000 WHERE InstructorID = 4;

SELECT MAX(i.Salary) AS MaxSalary
FROM Instructor i
JOIN Department d ON i.DepartmentID = d.DepartmentID
WHERE d.DepartName = 'Computer Science';

-- 9. 
SELECT d.DepartName, COUNT(e.StudentID) AS TotalStudents
FROM Department d
JOIN Courses c ON d.DepartmentID = c.DepartmentID
JOIN Enrollment e ON c.CourseID = e.CourseID
GROUP BY d.DepartName;

-- 10. 
SELECT s.FirstName, s.LastName, c.CourseName
FROM Students s
INNER JOIN Enrollment e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;

-- 11.
SELECT s.FirstName, s.LastName, c.CourseName
FROM Students s
LEFT JOIN Enrollment e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID;

-- 12. 
SELECT *
FROM Students
WHERE StudentID IN (
    SELECT StudentID
    FROM Enrollment
    WHERE CourseID IN (
        SELECT CourseID
        FROM Enrollment
        GROUP BY CourseID
        HAVING COUNT(StudentID) > 10
    )
);

-- 13. 
SELECT StudentID, YEAR(EnrollmentDate) AS Year
FROM Students;


-- 14. 
SELECT CONCAT(FirstName, ' ', LastName) AS FullName
FROM Instructor;

-- 15. 
SELECT CourseID,
COUNT(StudentID) OVER (PARTITION BY CourseID ORDER BY EnrollmentID) AS RunningTotal
FROM Enrollment;

-- 16. 
SELECT StudentID,
CASE 
    WHEN EnrollmentDate <= DATE_SUB(CURDATE(), INTERVAL 4 YEAR)
    THEN 'Senior'
    ELSE 'Junior'
END AS Status
FROM Students;