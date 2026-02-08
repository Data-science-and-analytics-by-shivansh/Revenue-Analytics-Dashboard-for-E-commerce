-- Create table for Online Retail data
CREATE TABLE OnlineRetail (
    InvoiceNo VARCHAR(50),
    StockCode VARCHAR(50),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10, 2),
    CustomerID INT,
    Country VARCHAR(100)
);

-- Sample INSERT (load via bulk import in production)
-- INSERT INTO OnlineRetail VALUES (...); -- Use CSV import tool like SSMS Import Wizard
