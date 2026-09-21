# ⚡ Data Transformer: Corporate Data Analysis 

> A robust, end-to-end relational data transformation pipeline and analysis system demonstrating advanced SQL querying, data manipulation, and automated reporting using Python.

---

## 📖 Project Overview

**Data Transformer** simulates an enterprise Corporate Data Analysis System[cite: 1]. It builds an integrated pipeline managing:
- **Customer Information Management**[cite: 1]
- **Sales Transaction Processing**[cite: 1]
- **Employee Performance & Payroll Metrics**[cite: 1]

The project illustrates practical execution of complex table joins, scalar and correlated subqueries, datetime formatting, string cleansing, window analytical functions, and dynamic conditional categorization via SQL `CASE` logic[cite: 1].

---

## 🏗 Database Schema & Sample Records

### 1. `Customers` Table[cite: 1]
| Column Name | Data Type | Key / Constraint | Description |
|---|---|---|---|
| `CustomerID` | INTEGER | PRIMARY KEY | Unique identifier for customer[cite: 1] |
| `FirstName` | VARCHAR(50) | NOT NULL | Customer first name[cite: 1] |
| `LastName` | VARCHAR(50) | NOT NULL | Customer last name[cite: 1] |
| `Email` | VARCHAR(100)| UNIQUE, NOT NULL | Primary contact email[cite: 1] |
| `RegistrationDate` | DATE | NOT NULL | Account signup date[cite: 1] |

*Sample Data:*[cite: 1]
| CustomerID | FirstName | LastName | Email | RegistrationDate |
|:---:|:---:|:---:|---|:---:|
| 1 | John | Doe | john.doe@email.com | 2022-03-15[cite: 1] |
| 2 | Jane | Smith | jane.smith@email.com | 2021-11-02[cite: 1] |

---

### 2. `Orders` Table[cite: 2]
| Column Name | Data Type | Key / Constraint | Description |
|---|---|---|---|
| `OrderID` | INTEGER | PRIMARY KEY | Unique identifier for order[cite: 2] |
| `CustomerID` | INTEGER | FOREIGN KEY (`Customers.CustomerID`) | Reference to customer[cite: 2] |
| `OrderDate` | DATE | NOT NULL | Timestamp/Date of order placed[cite: 2] |
| `TotalAmount` | DECIMAL(10,2)| NOT NULL | Total transaction monetary value[cite: 2] |

*Sample Data:*[cite: 2]
| OrderID | CustomerID | OrderDate | TotalAmount |
|:---:|:---:|:---:|:---:|
| 101 | 1 | 2023-07-01 | $150.50[cite: 2] |
| 102 | 2 | 2023-07-03 | $200.75[cite: 2] |

---

### 3. `Employees` Table[cite: 2, 3]
| Column Name | Data Type | Key / Constraint | Description |
|---|---|---|---|
| `EmployeeID` | INTEGER | PRIMARY KEY | Unique identifier for employee[cite: 3] |
| `FirstName` | VARCHAR(50) | NOT NULL | Employee first name[cite: 3] |
| `LastName` | VARCHAR(50) | NOT NULL | Employee last name[cite: 3] |
| `Department` | VARCHAR(50) | NOT NULL | Department assignment[cite: 3] |
| `HireDate` | DATE | NOT NULL | Date hired[cite: 3] |
| `Salary` | DECIMAL(10,2)| NOT NULL | Annual compensation[cite: 3] |

*Sample Data:*[cite: 3]
| EmployeeID | FirstName | LastName | Department | HireDate | Salary |
|:---:|:---:|:---:|:---:|:---:|:---:|
| 1 | Mark | Johnson | Sales | 2020-01-15 | $50,000.00[cite: 3] |
| 2 | Susan | Lee | HR | 2021-03-20 | $55,000.00[cite: 3] |

---

## 🎯 Analytical Queries Implemented

| # | Operation Category | Analytical Objective | Key Clauses / Techniques |
|:---:|---|---|---|
| **1** | Multi-Table Joins | Retrieve all orders and customer details where orders exist[cite: 3] | `INNER JOIN`[cite: 3] |
| **2** | Multi-Table Joins | Retrieve all customers and their corresponding orders (if any)[cite: 3] | `LEFT JOIN`[cite: 3] |
| **3** | Multi-Table Joins | Retrieve all orders and their corresponding customers (if any)[cite: 3] | `RIGHT JOIN`[cite: 3] |
| **4** | Multi-Table Joins | Full outer extraction of all orders and customers[cite: 3] | `FULL OUTER JOIN` (or `UNION` emulation)[cite: 3] |
| **5** | Subqueries | Find customers who placed orders higher than average order amount[cite: 3] | Scalar subquery with `WHERE TotalAmount > (SELECT AVG(...))`[cite: 3] |
| **6** | Subqueries | Identify employees earning above corporate departmental average salary[cite: 3] | Filter with `WHERE Salary > (SELECT AVG(...))`[cite: 3] |
| **7** | Date Operations | Extract Year and Month from `OrderDate`[cite: 3] | `strftime()`, `EXTRACT()`, or `YEAR()`/`MONTH()`[cite: 3] |
| **8** | Date Operations | Compute difference in days between `OrderDate` and current date[cite: 3] | `julianday()`, `DATEDIFF()`, or `DATE_PART()`[cite: 3] |
| **9** | Date Operations | Format order date to readable format (`DD-Mon-YYYY`)[cite: 3] | Date casting and formatting functions[cite: 3] |
| **10**| String Operations | Concatenate `FirstName` and `LastName` to form full name[cite: 4] | `CONCAT()`, `\|\|` operator[cite: 4] |
| **11**| String Operations | Replace target substring (e.g., 'John' to 'Jonathan')[cite: 4] | `REPLACE()`[cite: 4] |
| **12**| String Operations | Standardize capitalization (`FirstName` UPPER, `LastName` LOWER)[cite: 4] | `UPPER()`, `LOWER()`[cite: 4] |
| **13**| String Operations | Cleanse leading and trailing whitespaces from `Email`[cite: 4] | `TRIM()`[cite: 4] |
| **14**| Window Functions | Calculate running total of order transactions[cite: 4] | `SUM(TotalAmount) OVER(ORDER BY OrderDate)`[cite: 4] |
| **15**| Window Functions | Rank orders based on monetary total[cite: 4] | `RANK() OVER(ORDER BY TotalAmount DESC)`[cite: 4] |
| **16**| Conditional Logic | Dynamic discount allocation (> $1000: 10%, > $500: 5%)[cite: 4] | `CASE WHEN TotalAmount > 1000 ... END`[cite: 4] |
| **17**| Conditional Logic | Salary tier segmentation into High, Medium, or Low[cite: 4] | Multi-tier `CASE WHEN` evaluation[cite: 4] |

---

## 💻 Python Execution Script

This executable Python script sets up an in-memory SQLite database, populates the schema, and executes the 17 business queries.

```python
import sqlite3
import pandas as pd

def run_pipeline():
    conn = sqlite3.connect(":memory:")
    cursor = conn.cursor()

    # 1. Schema Definition & Data Seeding
    cursor.executescript("""
        CREATE TABLE Customers (
            CustomerID INTEGER PRIMARY KEY,
            FirstName TEXT NOT NULL,
            LastName TEXT NOT NULL,
            Email TEXT UNIQUE NOT NULL,
            RegistrationDate DATE NOT NULL
        );

        CREATE TABLE Orders (
            OrderID INTEGER PRIMARY KEY,
            CustomerID INTEGER,
            OrderDate DATE NOT NULL,
            TotalAmount REAL NOT NULL,
            FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
        );

        CREATE TABLE Employees (
            EmployeeID INTEGER PRIMARY KEY,
            FirstName TEXT NOT NULL,
            LastName TEXT NOT NULL,
            Department TEXT NOT NULL,
            HireDate DATE NOT NULL,
            Salary REAL NOT NULL
        );

        INSERT INTO Customers VALUES 
            (1, 'John', 'Doe', '  john.doe@email.com  ', '2022-03-15'),
            (2, 'Jane', 'Smith', 'jane.smith@email.com', '2021-11-02'),
            (3, 'Alex', 'Wong', 'alex.wong@email.com', '2023-01-10');

        INSERT INTO Orders VALUES 
            (101, 1, '2023-07-01', 150.50),
            (102, 2, '2023-07-03', 200.75),
            (103, 1, '2023-08-15', 650.00),
            (104, NULL, '2023-09-01', 1200.00);

        INSERT INTO Employees VALUES 
            (1, 'Mark', 'Johnson', 'Sales', '2020-01-15', 50000.00),
            (2, 'Susan', 'Lee', 'HR', '2021-03-20', 55000.00),
            (3, 'David', 'Kim', 'Engineering', '2019-06-01', 95000.00);
    """)

    queries = {
        "1. INNER JOIN (Matching Orders & Customers)": """
            SELECT o.OrderID, c.FirstName, c.LastName, o.OrderDate, o.TotalAmount
            FROM Orders o
            INNER JOIN Customers c ON o.CustomerID = c.CustomerID;
        """,
        "2. LEFT JOIN (All Customers with Orders)": """
            SELECT c.CustomerID, c.FirstName, c.LastName, o.OrderID, o.TotalAmount
            FROM Customers c
            LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;
        """,
        "5. Subquery (Orders Above Average Amount)": """
            SELECT CustomerID, OrderID, TotalAmount 
            FROM Orders 
            WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM Orders);
        """,
        "6. Subquery (Employees with Salary Above Average)": """
            SELECT FirstName, LastName, Department, Salary 
            FROM Employees 
            WHERE Salary > (SELECT AVG(Salary) FROM Employees);
        """,
        "7. Date Parsing (Year & Month Extracted)": """
            SELECT OrderID, OrderDate, 
                   strftime('%Y', OrderDate) AS OrderYear, 
                   strftime('%m', OrderDate) AS OrderMonth 
            FROM Orders;
        """,
        "8. Date Difference (Elapsed Days to Current Date)": """
            SELECT OrderID, OrderDate, 
                   CAST(julianday('now') - julianday(OrderDate) AS INTEGER) AS DaysSinceOrder 
            FROM Orders;
        """,
        "10. String Concatenation (Full Name)": """
            SELECT CustomerID, FirstName || ' ' || LastName AS FullName 
            FROM Customers;
        """,
        "11. String Replacement ('John' to 'Jonathan')": """
            SELECT CustomerID, REPLACE(FirstName, 'John', 'Jonathan') AS CleanedFirstName 
            FROM Customers;
        """,
        "12. String Casing (UPPER First, LOWER Last)": """
            SELECT UPPER(FirstName) AS FirstNameUpper, LOWER(LastName) AS LastNameLower 
            FROM Customers;
        """,
        "13. String Trimming (Clean Email)": """
            SELECT CustomerID, TRIM(Email) AS CleanEmail 
            FROM Customers;
        """,
        "14. Window Function (Running Total of Orders)": """
            SELECT OrderID, OrderDate, TotalAmount,
                   SUM(TotalAmount) OVER(ORDER BY OrderDate) AS RunningTotal
            FROM Orders;
        """,
        "15. Window Function (Rank Orders by TotalAmount)": """
            SELECT OrderID, TotalAmount,
                   RANK() OVER(ORDER BY TotalAmount DESC) AS OrderRank
            FROM Orders;
        """,
        "16. CASE Expression (Order Discount Bracket)": """
            SELECT OrderID, TotalAmount,
                   CASE 
                       WHEN TotalAmount > 1000 THEN '10% off'
                       WHEN TotalAmount > 500  THEN '5% off'
                       ELSE 'No Discount'
                   END AS DiscountTier
            FROM Orders;
        """,
        "17. CASE Expression (Employee Salary Categorization)": """
            SELECT FirstName, LastName, Salary,
                   CASE 
                       WHEN Salary >= 80000 THEN 'High'
                       WHEN Salary >= 52000 THEN 'Medium'
                       ELSE 'Low'
                   END AS SalaryGrade
            FROM Employees;
        """
    }

    # Execute and display analytical reports
    for title, query in queries.items():
        print(f"\n{'='*25} {title} {'='*25}")
        df = pd.read_sql_query(query, conn)
        print(df.to_string(index=False))

    conn.close()

if __name__ == "__main__":
    run_pipeline()
