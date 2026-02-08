-- Sales Trends (Daily Revenue)
SELECT 
    CAST(InvoiceDate AS DATE) AS Date,
    SUM(Quantity * UnitPrice) AS DailyRevenue
FROM OnlineRetail
WHERE Quantity > 0  -- Exclude cancellations
GROUP BY CAST(InvoiceDate AS DATE)
ORDER BY Date;

-- Customer Cohorts (First Purchase Month and Retention)
WITH FirstPurchase AS (
    SELECT 
        CustomerID,
        MIN(CAST(InvoiceDate AS DATE)) AS FirstPurchaseDate,
        FORMAT(MIN(InvoiceDate), 'yyyy-MM') AS CohortMonth
    FROM OnlineRetail
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
),
CohortActivity AS (
    SELECT 
        fp.CohortMonth,
        DATEDIFF(MONTH, CONVERT(DATETIME, fp.CohortMonth + '-01'), CAST(or2.InvoiceDate AS DATE)) AS MonthsSinceCohort,
        COUNT(DISTINCT or2.CustomerID) AS ActiveCustomers
    FROM OnlineRetail or2
    JOIN FirstPurchase fp ON or2.CustomerID = fp.CustomerID
    WHERE or2.Quantity > 0
    GROUP BY fp.CohortMonth, DATEDIFF(MONTH, CONVERT(DATETIME, fp.CohortMonth + '-01'), CAST(or2.InvoiceDate AS DATE))
)
SELECT 
    CohortMonth,
    MonthsSinceCohort,
    ActiveCustomers
FROM CohortActivity
ORDER BY CohortMonth, MonthsSinceCohort;

-- Top Products by Revenue
SELECT 
    StockCode,
    Description,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM OnlineRetail
WHERE Quantity > 0
GROUP BY StockCode, Description
ORDER BY TotalRevenue DESC
TOP 10;

-- Profit Trends (Assuming 70% margin; adjust as needed)
SELECT 
    FORMAT(InvoiceDate, 'yyyy-MM') AS Month,
    SUM(Quantity * UnitPrice) AS Revenue,
    SUM(Quantity * UnitPrice * 0.70) AS EstimatedProfit  -- Placeholder margin
FROM OnlineRetail
WHERE Quantity > 0
GROUP BY FORMAT(InvoiceDate, 'yyyy-MM')
ORDER BY Month;
