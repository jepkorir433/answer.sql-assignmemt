

-- ======================
-- ORIGINAL TABLE (DENORMALIZED)
-- ======================
-- | OrderID | CustomerName | Products               |
-- |---------|--------------|------------------------|
-- | J01     | John Doe     | Laptop, Mouse          

-- Create 1NF table (atomic values)
DROP TABLE IF EXISTS ProductDetail_1NF;
CREATE TABLE ProductDetail_1NF (
    OrderID VARCHAR(10),
    CustomerName VARCHAR(100),
    Product VARCHAR(50)
);

-- Insert split data
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
    ('J01', 'John Doe', 'Laptop'),
    ('J01', 'John Doe', 'Mouse'),
    ('J02', 'Jane Smith', 'Tablet'),
    ('J02', 'Jane Smith', 'Keyboard'),
    ('J02', 'Jane Smith', 'Mouse'),
    ('J03', 'Emily Clark', 'Phone');

-- Verification output for 1NF
SELECT '=== 1NF RESULTS ===' AS verification;
SELECT * FROM ProductDetail_1NF ORDER BY OrderID, Product;

-- Expected output:
-- | OrderID | CustomerName | Product  |
-- |---------|--------------|----------|
-- | J01     | John Doe     | Laptop   |
-- | J01     | John Doe     | Mouse    |
-- | J02     | Jane Smith   | Keyboard |
-- | J02     | Jane Smith   | Mouse    |
-- | J02     | Jane Smith   | Tablet   |
-- | J03     | Emily Clark  | Phone    |

-- =============================================
-- QUESTION 2 SOLUTION: ACHIEVING 2NF
-- =============================================

-- Create Orders table (removes partial dependency)
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
    OrderID VARCHAR(10) PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Create OrderItems table
DROP TABLE IF EXISTS OrderItems;
CREATE TABLE OrderItems (
    OrderID VARCHAR(10),
    Product VARCHAR(50),
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Populate normalized tables
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName FROM ProductDetail_1NF;

INSERT INTO OrderItems (OrderID, Product)
SELECT OrderID, Product FROM ProductDetail_1NF;

-- Verification output for 2NF
SELECT '=== ORDERS TABLE ===' AS verification;
SELECT * FROM Orders ORDER BY OrderID;

SELECT '=== ORDERITEMS TABLE ===' AS verification;
SELECT * FROM OrderItems ORDER BY OrderID, Product;

-- Expected Orders output:
-- | OrderID | CustomerName |
-- |---------|--------------|
-- | J01     | John Doe     |
-- | J02     | Jane Smith   |
-- | J03     | Emily Clark  |

-- Expected OrderItems output:
-- | OrderID | Product  |
-- |---------|----------|
-- | J01     | Laptop   |
-- | J01     | Mouse    |
-- | J02     | Keyboard |
-- | J02     | Mouse    |
-- | J02     | Tablet   |
-- | J03     | Phone    |