CREATE DATABASE IF NOT EXISTS DataTransformerDB;

USE DataTransformerDB;


CREATE TABLE Customers
(
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    RegistrationDate DATE
);

INSERT INTO Customers
VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2022-03-15'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '2021-11-02');


CREATE TABLE Orders
(
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders
VALUES
(101, 1, '2023-07-01', 150.50),
(102, 2, '2023-07-03', 200.75);


CREATE TABLE Employees
(
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10,2)
);

INSERT INTO Employees
VALUES
(1, 'Mark', 'Johnson', 'Sales', '2020-01-15', 50000.00),
(2, 'Susan', 'Lee', 'HR', '2021-03-20', 55000.00);


SELECT o.OrderID, o.OrderDate, o.TotalAmount,
       c.FirstName, c.LastName, c.Email
FROM Orders o
INNER JOIN Customers c
ON o.CustomerID = c.CustomerID;


SELECT c.CustomerID, c.FirstName, c.LastName,
       o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers c
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID;


SELECT o.OrderID, o.OrderDate, o.TotalAmount,
       c.FirstName, c.LastName
FROM Customers c
RIGHT JOIN Orders o
ON c.CustomerID = o.CustomerID;


SELECT c.CustomerID, c.FirstName, c.LastName,
       o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers c
LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID

UNION

SELECT c.CustomerID, c.FirstName, c.LastName,
       o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers c
RIGHT JOIN Orders o
ON c.CustomerID = o.CustomerID;


SELECT *
FROM Customers
WHERE CustomerID IN
(
    SELECT CustomerID
    FROM Orders
    WHERE TotalAmount >
    (
        SELECT AVG(TotalAmount)
        FROM Orders
    )
);


SELECT *
FROM Employees
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM Employees
);


SELECT OrderID,
       OrderDate,
       YEAR(OrderDate) AS OrderYear,
       MONTH(OrderDate) AS OrderMonth
FROM Orders;


SELECT OrderID,
       OrderDate,
       DATEDIFF(CURDATE(), OrderDate) AS Days
FROM Orders;


SELECT OrderID,
       DATE_FORMAT(OrderDate, '%d-%b-%Y') AS FormattedDate
FROM Orders;


SELECT CustomerID,
       CONCAT(FirstName, ' ', LastName) AS FullName
FROM Customers;


SELECT CustomerID,
       REPLACE(FirstName, 'John', 'Jonathan') AS FirstName
FROM Customers;


SELECT CustomerID,
       UPPER(FirstName) AS FirstName,
       LOWER(LastName) AS LastName
FROM Customers;


SELECT CustomerID,
       TRIM(Email) AS Email
FROM Customers;


SELECT OrderID,
       TotalAmount,
       SUM(TotalAmount) OVER
       (
           ORDER BY OrderDate, OrderID
       ) AS RunningTotal
FROM Orders;


SELECT OrderID,
       TotalAmount,
       RANK() OVER
       (
           ORDER BY TotalAmount DESC
       ) AS OrderRank
FROM Orders;


SELECT OrderID,
       TotalAmount,
       CASE
           WHEN TotalAmount > 1000 THEN '10% Off'
           WHEN TotalAmount > 500 THEN '5% Off'
           ELSE 'No Discount'
       END AS Discount
FROM Orders;


SELECT EmployeeID,
       FirstName,
       LastName,
       Salary,
       CASE
           WHEN Salary >= 55000 THEN 'High'
           WHEN Salary >= 50000 THEN 'Medium'
           ELSE 'Low'
       END AS SalaryCategory
FROM Employees;