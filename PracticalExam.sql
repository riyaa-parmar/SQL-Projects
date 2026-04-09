CREATE DATABASE LibraryDB;
USE LibraryDB;

CREATE TABLE Authors(
Author_id INT PRIMARY KEY,
Name VARCHAR(50),
Email VARCHAR(100)
);

CREATE TABLE Books(
Book_id INT PRIMARY KEY,
Title VARCHAR(100),
Author_id INT,
Category VARCHAR(50),
ISBN VARCHAR(100),
Published_date DATE,
Price DECIMAL(10,2),
FOREIGN KEY (Author_id) REFERENCES Authors(Author_id)
);


CREATE TABLE Members(
Member_id INT PRIMARY KEY,
Name VARCHAR(50),
Email VARCHAR(100),
Phone_number INT,
Membership_date DATE 
);

CREATE TABLE Transactions(
Transaction_id INT PRIMARY KEY,
Member_id INT,
Book_id INT,
Borrow_date DATE,
Return_date DATE,
Fine_amount DECIMAL(10,2),
FOREIGN KEY (Member_id) REFERENCES Members(Member_id),
FOREIGN KEY (Book_id) REFERENCES Books(Book_id)
);

INSERT INTO Authors(Author_id, Name, Email)
VALUES
(1, 'Chetan Bhagat', 'chetan@gmail.com'),
(2, 'J.K. Rowling', 'jk@gmail.com'),
(3, 'APJ Abdul Kalam', NULL),
(4, 'Ruskin Bond', 'ruskin@gmail.com'),
(5, 'R.K. Narayan', NULL);

INSERT INTO Books(Book_id, Title, Author_id, Category, ISBN, Published_date, Price)
VALUES
(1, '2 States', 1, 'Fiction', 'ISBN001', '2015-01-01', 300),
(2, 'Harry Potter', 2, 'Fantasy', 'ISBN002', '2000-06-01', 800),
(3, 'Wings of Fire', 3, 'Science', 'ISBN003', '1999-05-10', 450),
(4, 'The Blue Umbrella', 4, 'Fiction', 'ISBN004', '1980-03-15', 250),
(5, 'Malgudi Days', 5, 'Classic', 'ISBN005', '1943-07-20', 350);

INSERT INTO Members(Member_id, Name, Email, Phone_number, Membership_date)
VALUES
(1, 'Riya', 'riya@gmail.com', '99999999', '2021-01-01'),
(2, 'Amit', NULL, '88888888', '2023-02-10'),
(3, 'Neha', 'neha@gmail.com', '77777777', '2022-05-05'),
(4, 'Rahul', NULL, '66666666', '2020-08-12'),
(5, 'Priya', 'priya@gmail.com', '55555555', '2019-11-25');

INSERT INTO Transactions(Transaction_id, Member_id, Book_id, Borrow_date, Return_date, Fine_amount)
VALUES
(1, 1, 1, '2024-01-01', '2024-01-10', 0),
(2, 1, 2, '2024-02-01', '2024-02-20', 50),
(3, 2, 3, '2024-03-01', NULL, 0),
(4, 3, 1, '2024-03-10', '2024-03-18', 0),
(5, 4, 4, '2024-04-01', NULL, 20);

-- 1. CRUD Operations

-- Insert a new book
INSERT INTO Books VALUES (6, 'Data Science', 1, 'Science', 'ISBN006', '2022-01-01', 600);

-- Update price of a book
UPDATE Books 
SET Price = 700 
WHERE Book_id = 2;

-- Delete members who never borrowed
DELETE FROM Members
WHERE Member_id NOT IN (
    SELECT Member_id FROM Transactions
);

-- Retrieve all Books
SELECT * FROM Books;

-- Retrieve all Authors
SELECT * FROM Authors;

-- Retrieve all Members
SELECT * FROM Members;

-- Retrieve all Transactions
SELECT * FROM Transactions;

-- 2. Clauses (Where, Having, Limit)

-- Books published after 2015
SELECT * FROM Books
WHERE YEAR(Published_date) > 2015;

-- Top 5 expensive books
SELECT * FROM Books
ORDER BY Price DESC
LIMIT 5;

-- Members joined before 2022
SELECT * FROM Members
WHERE YEAR(Membership_date) < 2022;

-- 3. Operators (AND, OR, NOT)

-- Science books under 500
SELECT * FROM Books
WHERE Category = 'Science' AND Price < 500;

-- Books not returned yet
SELECT * FROM Transactions
WHERE Return_date IS NULL;

-- Members joined after 2020 OR borrowed more than 3 books
SELECT * FROM Members
WHERE YEAR(Membership_date) > 2020
OR Member_id IN (
    SELECT Member_id
    FROM Transactions
    GROUP BY Member_id
    HAVING COUNT(*) > 3
);

-- 4. Sorting and Grouping Data (ORDER BY, GROUP BY)

-- Sort books alphabetically
SELECT * FROM Books
ORDER BY Title ASC;

-- Number of books borrowed by each member
SELECT Member_id, COUNT(*) AS Total_Books
FROM Transactions
GROUP BY Member_id;

-- Books count by category
SELECT Category, COUNT(*) AS Total
FROM Books
GROUP BY Category;

-- 5. Aggregate Functions (SUM, MIN, MAX, AVG, Count)

-- Total books per category
SELECT Category, COUNT(*) 
FROM Books
GROUP BY Category;

-- Average book price
SELECT AVG(Price) FROM Books;

-- Most borrowed book
SELECT Book_id, COUNT(*) AS Total
FROM Transactions
GROUP BY Book_id
ORDER BY Total DESC
LIMIT 1;

-- Total fines collected
SELECT SUM(Fine_amount) FROM Transactions;

-- 6. primary key & foreign key relationships

-- Books linked with Authors
SELECT B.Title, A.Name
FROM Books B
INNER JOIN Authors A 
ON B.Author_id = A.Author_id;

-- Transactions linked with Members and Books
SELECT T.Transaction_id, M.Name, B.Title
FROM Transactions T
INNER JOIN Members M 
ON T.Member_id = M.Member_id
INNER JOIN Books B 
ON T.Book_id = B.Book_id;

-- 7. Joins

-- INNER JOIN (Books with Authors)
SELECT B.Title, A.Name
FROM Books B
INNER JOIN Authors A 
ON B.Author_id = A.Author_id;

-- LEFT JOIN (Members with Transactions)
SELECT M.Name, T.Transaction_id
FROM Members M
LEFT JOIN Transactions T 
ON M.Member_id = T.Member_id;

-- RIGHT JOIN (Books with Transactions)
SELECT B.Title, T.Transaction_id
FROM Transactions T
RIGHT JOIN Books B 
ON T.Book_id = B.Book_id;

-- FULL OUTER JOIN (MySQL workaround)
SELECT M.Name, T.Transaction_id
FROM Members M
LEFT JOIN Transactions T ON M.Member_id = T.Member_id
UNION
SELECT M.Name, T.Transaction_id
FROM Members M
RIGHT JOIN Transactions T ON M.Member_id = T.Member_id;

-- 8. Subquery

-- Books borrowed by members registered after 2022
SELECT * FROM Books
WHERE Book_id IN (
    SELECT Book_id FROM Transactions
    WHERE Member_id IN (
        SELECT Member_id FROM Members
        WHERE YEAR(Membership_date) > 2022
    )
);

-- Most borrowed book details
SELECT * FROM Books
WHERE Book_id = (
    SELECT Book_id
    FROM Transactions
    GROUP BY Book_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- Members who never borrowed
SELECT * FROM Members
WHERE Member_id NOT IN (
    SELECT Member_id FROM Transactions
);

-- 9. Date & Time Functions

-- Extract year
SELECT YEAR(Published_date) FROM Books;

-- Difference between borrow and return
SELECT DATEDIFF(Return_date, Borrow_date) FROM Transactions;

-- Format date
SELECT DATE_FORMAT(Borrow_date, '%d-%m-%Y') as Formatted_date FROM Transactions; 

-- 10. String Manipulation Function

-- Uppercase titles
SELECT UPPER(Title) AS Upper_Title FROM Books;

-- Trim author names
SELECT TRIM(Name) AS Clean_Name FROM Authors;

-- Replace NULL emails
SELECT IFNULL(Email, 'Not Provided') AS Email_Status FROM Members;

-- 11. Window Functions

-- Rank books by borrowing count
SELECT Book_id,
RANK() OVER (ORDER BY COUNT(*) DESC) AS Rank_No
FROM Transactions
GROUP BY Book_id;

-- Total books per member
SELECT Member_id,
COUNT(*) OVER (PARTITION BY Member_id) AS Total
FROM Transactions;

-- Moving average of fines
SELECT 
    Book_id AS Book_ID,
    AVG(Fine_amount) OVER (
        ORDER BY Borrow_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS Moving_Avg_Fine
FROM Transactions;

-- 12. Case Statement

-- Membership status
SELECT Member_id,
CASE
    WHEN Member_id IN (
        SELECT Member_id FROM Transactions
        WHERE Borrow_date > DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
    ) THEN 'Active'
    ELSE 'Inactive'
END AS Status
FROM Members;

-- Book classification
SELECT Title,
CASE
    WHEN YEAR(Published_date) > 2020 THEN 'New Arrival'
    WHEN YEAR(Published_date) < 2000 THEN 'Classic'
    ELSE 'Regular'
END AS Category_Type
FROM Books;