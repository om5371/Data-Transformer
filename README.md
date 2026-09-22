# Data Transformer — SQL Query Guide

## Objective

This document walks through **`Data_Transformer.sql`** query by query. For every query it explains, in plain language, *what the query does and why*, shows the original SQL exactly as written in the script, and shows the **actual output** the query produces, rendered as a Markdown table.

## Database Schema

| Table | Columns |
| --- | --- |
| **Customers** | CustomerID (PK), FirstName, LastName, Email, RegistrationDate |
| **Orders** | OrderID (PK), CustomerID (FK → Customers), OrderDate, TotalAmount |
| **Employees** | EmployeeID (PK), FirstName, LastName, Department, HireDate, Salary |

## Sample Data

**Customers**

| CustomerID | FirstName | LastName | Email | RegistrationDate |
| --- | --- | --- | --- | --- |
| 1 | John | Doe | john.doe@email.com | 2022-03-15 |
| 2 | Jane | Smith | jane.smith@email.com | 2021-11-02 |

**Orders**

| OrderID | CustomerID | OrderDate | TotalAmount |
| --- | --- | --- | --- |
| 101 | 1 | 2023-07-01 | 150.5 |
| 102 | 2 | 2023-07-03 | 200.75 |

**Employees**

| EmployeeID | FirstName | LastName | Department | HireDate | Salary |
| --- | --- | --- | --- | --- | --- |
| 1 | Mark | Johnson | Sales | 2020-01-15 | 50000 |
| 2 | Susan | Lee | HR | 2021-03-20 | 55000 |

---

## Queries

### 1. INNER JOIN

**Objective:** Retrieve all orders together with the details of the customer who placed each order. Only rows that have a match in BOTH tables are returned.

**SQL:**

```sql
SELECT
    o.OrderID,
    o.OrderDate,
    o.TotalAmount,
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email
FROM Orders o
INNER JOIN Customers c
    ON o.CustomerID = c.CustomerID;
```

**Output:**

| OrderID | OrderDate | TotalAmount | CustomerID | FirstName | LastName | Email |
| --- | --- | --- | --- | --- | --- | --- |
| 101 | 2023-07-01 | 150.5 | 1 | John | Doe | john.doe@email.com |
| 102 | 2023-07-03 | 200.75 | 2 | Jane | Smith | jane.smith@email.com |

### 2. LEFT JOIN

**Objective:** Retrieve every customer, and any orders they have placed. Customers with no orders still appear, with NULL in the order columns.

**SQL:**

```sql
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Email,
    o.OrderID,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID;
```

**Output:**

| CustomerID | FirstName | LastName | Email | OrderID | OrderDate | TotalAmount |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | John | Doe | john.doe@email.com | 101 | 2023-07-01 | 150.5 |
| 2 | Jane | Smith | jane.smith@email.com | 102 | 2023-07-03 | 200.75 |

### 3. RIGHT JOIN

**Objective:** Retrieve every order together with its matching customer. This is the mirror image of a LEFT JOIN: every order is kept, even if its customer were missing.

**SQL:**

```sql
SELECT
    o.OrderID,
    o.OrderDate,
    o.TotalAmount,
    c.CustomerID,
    c.FirstName,
    c.LastName
FROM Customers c
RIGHT JOIN Orders o
    ON c.CustomerID = o.CustomerID;
```

> **Note:** SQLite has no native `RIGHT JOIN`, so it was rewritten as an equivalent `LEFT JOIN` with the table order swapped (Orders LEFT JOIN Customers). The result is identical to the RIGHT JOIN in the original script.

**Output:**

| OrderID | OrderDate | TotalAmount | CustomerID | FirstName | LastName |
| --- | --- | --- | --- | --- | --- |
| 101 | 2023-07-01 | 150.5 | 1 | John | Doe |
| 102 | 2023-07-03 | 200.75 | 2 | Jane | Smith |

### 4. FULL OUTER JOIN

**Objective:** Retrieve every customer and every order, matched where possible, and kept even when there is no match on either side.

**SQL:**

```sql
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    o.OrderID,
    o.OrderDate,
    o.TotalAmount
FROM Customers c
FULL OUTER JOIN Orders o
    ON c.CustomerID = o.CustomerID;
```

> **Note:** Emulated with `LEFT JOIN ... UNION ... LEFT JOIN` (table order swapped in the second half), exactly as the comment in the original script suggests for MySQL.

**Output:**

| CustomerID | FirstName | LastName | OrderID | OrderDate | TotalAmount |
| --- | --- | --- | --- | --- | --- |
| 1 | John | Doe | 101 | 2023-07-01 | 150.5 |
| 2 | Jane | Smith | 102 | 2023-07-03 | 200.75 |

### 5. Subquery — customers above average order amount

**Objective:** Find the customers who have placed at least one order worth more than the average order amount across all orders.

**SQL:**

```sql
SELECT DISTINCT
    c.CustomerID,
    c.FirstName,
    c.LastName
FROM Customers c
WHERE c.CustomerID IN (
    SELECT CustomerID
    FROM Orders
    WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM Orders)
);
```

**Output:**

| CustomerID | FirstName | LastName |
| --- | --- | --- |
| 2 | Jane | Smith |

### 6. Subquery — employees above average salary

**Objective:** Find employees whose salary is above the average salary of all employees.

**SQL:**

```sql
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Department,
    Salary
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);
```

**Output:**

| EmployeeID | FirstName | LastName | Department | Salary |
| --- | --- | --- | --- | --- |
| 2 | Susan | Lee | HR | 55000 |

### 7. Extract year and month from OrderDate

**Objective:** Break the OrderDate column into its Year and Month components.

**SQL:**

```sql
SELECT
    OrderID,
    OrderDate,
    EXTRACT(YEAR FROM OrderDate) AS OrderYear,
    EXTRACT(MONTH FROM OrderDate) AS OrderMonth
FROM Orders;
```

> **Note:** SQLite has no `EXTRACT()`. It was rewritten using `strftime('%Y', ...)` and `strftime('%m', ...)`, which return the same year/month values.

**Output:**

| OrderID | OrderDate | OrderYear | OrderMonth |
| --- | --- | --- | --- |
| 101 | 2023-07-01 | 2023 | 7 |
| 102 | 2023-07-03 | 2023 | 7 |

### 8. Days between OrderDate and current date

**Objective:** Calculate how many days have passed between each order's date and today's date.

**SQL:**

```sql
SELECT
    OrderID,
    OrderDate,
    CURRENT_DATE AS TodayDate,
    (CURRENT_DATE - OrderDate) AS DaysDifference
FROM Orders;
```

> **Note:** SQLite stores dates as text, so `CURRENT_DATE - OrderDate` does not subtract days directly. The equivalent is `julianday(a) - julianday(b)`. `TodayDate` is pinned to **2025-01-01** here so the output below is reproducible; running the original SQL live returns the actual current date instead.

**Output:**

| OrderID | OrderDate | TodayDate | DaysDifference |
| --- | --- | --- | --- |
| 101 | 2023-07-01 | 2025-01-01 | 550 |
| 102 | 2023-07-03 | 2025-01-01 | 548 |

### 9. Format OrderDate as DD-Mon-YYYY

**Objective:** Reformat OrderDate into a more human-readable form, e.g. 01-Jul-2023.

**SQL:**

```sql
SELECT
    OrderID,
    TO_CHAR(OrderDate, 'DD-Mon-YYYY') AS FormattedDate
FROM Orders;
```

> **Note:** SQLite has no `TO_CHAR()`. The `FormattedDate` column below was produced by post-processing the raw `OrderDate` in Python (equivalent to PostgreSQL's `TO_CHAR(OrderDate, 'DD-Mon-YYYY')` / MySQL's `DATE_FORMAT(..., '%d-%b-%Y')`).

**Output:**

| OrderID | FormattedDate |
| --- | --- |
| 101 | 01-Jul-2023 |
| 102 | 03-Jul-2023 |

### 10. Concatenate FirstName and LastName

**Objective:** Build a single FullName column out of FirstName and LastName.

**SQL:**

```sql
SELECT
    CustomerID,
    CONCAT(FirstName, ' ', LastName) AS FullName
FROM Customers;
```

> **Note:** SQLite has no `CONCAT()`; the `||` string-concatenation operator does the same job.

**Output:**

| CustomerID | FullName |
| --- | --- |
| 1 | John Doe |
| 2 | Jane Smith |

### 11. Replace part of a string

**Objective:** Replace every occurrence of 'John' in FirstName with 'Jonathan'.

**SQL:**

```sql
SELECT
    CustomerID,
    FirstName,
    REPLACE(FirstName, 'John', 'Jonathan') AS ModifiedFirstName
FROM Customers;
```

**Output:**

| CustomerID | FirstName | ModifiedFirstName |
| --- | --- | --- |
| 1 | John | Jonathan |
| 2 | Jane | Jane |

### 12. Uppercase FirstName / lowercase LastName

**Objective:** Standardize casing: FirstName in uppercase, LastName in lowercase.

**SQL:**

```sql
SELECT
    CustomerID,
    UPPER(FirstName) AS UpperFirstName,
    LOWER(LastName) AS LowerLastName
FROM Customers;
```

**Output:**

| CustomerID | UpperFirstName | LowerLastName |
| --- | --- | --- |
| 1 | JOHN | doe |
| 2 | JANE | smith |

### 13. Trim extra spaces from Email

**Objective:** Remove leading/trailing whitespace from the Email field.

**SQL:**

```sql
SELECT
    CustomerID,
    TRIM(Email) AS CleanEmail
FROM Customers;
```

**Output:**

| CustomerID | CleanEmail |
| --- | --- |
| 1 | john.doe@email.com |
| 2 | jane.smith@email.com |

### 14. Running total of TotalAmount

**Objective:** Calculate a cumulative (running) sum of TotalAmount, ordered by OrderDate.

**SQL:**

```sql
SELECT
    OrderID,
    OrderDate,
    TotalAmount,
    SUM(TotalAmount) OVER (ORDER BY OrderDate, OrderID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM Orders;
```

**Output:**

| OrderID | OrderDate | TotalAmount | RunningTotal |
| --- | --- | --- | --- |
| 101 | 2023-07-01 | 150.5 | 150.5 |
| 102 | 2023-07-03 | 200.75 | 351.25 |

### 15. Rank orders by TotalAmount

**Objective:** Rank orders from highest to lowest TotalAmount using the RANK() window function.

**SQL:**

```sql
SELECT
    OrderID,
    CustomerID,
    TotalAmount,
    RANK() OVER (ORDER BY TotalAmount DESC) AS OrderRank
FROM Orders;
```

**Output:**

| OrderID | CustomerID | TotalAmount | OrderRank |
| --- | --- | --- | --- |
| 102 | 2 | 200.75 | 1 |
| 101 | 1 | 150.5 | 2 |

### 16. Discount tiers based on TotalAmount

**Objective:** Assign a discount tier and compute the final payable amount: >1000 -> 10% off, >500 -> 5% off, otherwise no discount.

**SQL:**

```sql
SELECT
    OrderID,
    TotalAmount,
    CASE
        WHEN TotalAmount > 1000 THEN '10% off'
        WHEN TotalAmount > 500 THEN '5% off'
        ELSE 'No Discount'
    END AS DiscountTier,
    CASE
        WHEN TotalAmount > 1000 THEN TotalAmount * 0.90
        WHEN TotalAmount > 500 THEN TotalAmount * 0.95
        ELSE TotalAmount
    END AS FinalAmount
FROM Orders;
```

**Output:**

| OrderID | TotalAmount | DiscountTier | FinalAmount |
| --- | --- | --- | --- |
| 101 | 150.5 | No Discount | 150.5 |
| 102 | 200.75 | No Discount | 200.75 |

### 17. Categorize employee salaries

**Objective:** Bucket each employee's salary into High, Medium, or Low.

**SQL:**

```sql
SELECT
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    CASE
        WHEN Salary >= 55000 THEN 'High'
        WHEN Salary >= 50000 THEN 'Medium'
        ELSE 'Low'
    END AS SalaryCategory
FROM Employees;
```

**Output:**

| EmployeeID | FirstName | LastName | Salary | SalaryCategory |
| --- | --- | --- | --- | --- |
| 1 | Mark | Johnson | 50000 | Medium |
| 2 | Susan | Lee | 55000 | High |

---
