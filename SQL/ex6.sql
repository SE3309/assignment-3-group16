-- Automatic Breach Resolution

UPDATE Breach
SET resolutionStatus = 'Auto-Resolved'
WHERE resolutionStatus = 'Pending Review'
  AND EXISTS (
        SELECT 1
        FROM Position p
        WHERE p.userID = Breach.userID
          AND p.commodityCode = Breach.commodityCode
          AND p.exchangeCode = Breach.exchangeCode
          AND ABS(p.quantity) <= 1000
          AND p.mtmValue >= -50000
    );


-- Delete a user's most recent transaction
DELETE FROM `Transaction`
WHERE userID = 300
  AND transactionDate = (
        SELECT maxDate 
        FROM (
            SELECT MAX(transactionDate) AS maxDate
            FROM `Transaction`
            WHERE userID = 300
        ) AS tmp
    );

-- Identify high risk traders

UPDATE User
SET role = 'High Risk Trader'
WHERE userID IN (
    SELECT userID
    FROM Position
    GROUP BY userID
    HAVING SUM(mtmValue) < -200000
);


-- Update Users Last Login

UPDATE User
SET lastLogin = CURRENT_TIMESTAMP
WHERE userID = '1'

-- Update currency conversion

UPDATE Currency 
SET conversionRate = '0.7'
WHERE currencyCode='CAD';