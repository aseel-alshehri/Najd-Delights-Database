-- Najd Delights Database
-- Academic SQL project using MySQL.
-- Uses sample data only. Review the script before running it on any database server.

CREATE DATABASE IF NOT EXISTS najd_delights;
USE najd_delights;

CREATE TABLE IF NOT EXISTS Customer (
    Customer_ID INT PRIMARY KEY,
    Fname VARCHAR(100) NOT NULL,
    Lname VARCHAR(100) NOT NULL,
    Phone_Number VARCHAR(10) UNIQUE
);

CREATE TABLE IF NOT EXISTS Dish (
    Dish_ID INT PRIMARY KEY,
    Dish_Name VARCHAR(100) NOT NULL,
    Category VARCHAR(100) NOT NULL,
    Dish_Price DECIMAL(8,2) NOT NULL,
    CONSTRAINT chk_dish_price_positive CHECK (Dish_Price > 0)
);

CREATE TABLE IF NOT EXISTS Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT NULL,
    Order_Date DATETIME,
    Payment_Method VARCHAR(50) DEFAULT 'Card',
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

-- Sample data: fictional names and placeholder phone numbers.
INSERT INTO Customer (Customer_ID, Fname, Lname, Phone_Number) VALUES
(1, 'Sara', 'Ahmed', '0500000001'),
(2, 'Khalid', 'Ali', '0500000002'),
(5, 'Aseel', 'Alshehri', '0500000005');

INSERT INTO Dish (Dish_ID, Dish_Name, Category, Dish_Price) VALUES
(1, 'Saleeq', 'Main_Dish', 45.00),
(2, 'Kabsa', 'Main_Dish', 55.00);

INSERT INTO Orders (Order_ID, Customer_ID, Order_Date, Payment_Method) VALUES
(101, 1, '2026-04-20 12:00:00', 'Cash'),
(102, 2, '2026-04-21 13:00:00', 'Card'),
(105, NULL, '2026-04-23 14:00:00', 'Cash');

-- Aggregate queries
SELECT MIN(Dish_Price) AS min_dish_price FROM Dish;
SELECT MAX(Dish_Price) AS max_dish_price FROM Dish;
SELECT MIN(Dish_Price) AS min_dish_price,
       MAX(Dish_Price) AS max_dish_price
FROM Dish;

SELECT COUNT(*) AS total_orders FROM Orders;
SELECT COUNT(*) AS card_payments
FROM Orders
WHERE Payment_Method = 'Card';

SELECT COUNT(DISTINCT Customer_ID) AS unique_customers
FROM Orders
WHERE Customer_ID IS NOT NULL;

SELECT SUM(Dish_Price) AS total_menu_value FROM Dish;
SELECT AVG(Dish_Price) AS average_price FROM Dish;

SELECT Category, COUNT(*) AS total_dishes
FROM Dish
GROUP BY Category;

-- JOIN examples
SELECT Customer.Fname, Customer.Lname, Orders.Order_ID
FROM Customer
LEFT JOIN Orders ON Customer.Customer_ID = Orders.Customer_ID;

SELECT Customer.Fname, Customer.Lname, Orders.Order_ID
FROM Customer
INNER JOIN Orders ON Customer.Customer_ID = Orders.Customer_ID;

-- Subquery examples
SELECT Dish_Name, Dish_Price
FROM Dish
WHERE Dish_Price > (SELECT AVG(Dish_Price) FROM Dish);

SELECT Fname, Lname
FROM Customer
WHERE Customer_ID IN (
    SELECT Customer_ID
    FROM Orders
    WHERE Customer_ID IS NOT NULL
);

-- Update example
UPDATE Orders
SET Payment_Method = 'Card'
WHERE Customer_ID = (
    SELECT Customer_ID
    FROM Customer
    WHERE Fname = 'Sara'
    LIMIT 1
);

-- View example
CREATE OR REPLACE VIEW Cash_Orders AS
SELECT Order_ID, Customer_ID, Order_Date, Payment_Method
FROM Orders
WHERE Payment_Method = 'Cash';

SELECT * FROM Cash_Orders;

-- Uncomment this statement if you want to remove the view:
-- DROP VIEW Cash_Orders;
