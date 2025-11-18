-- Automatic Breach Resolution

UPDATE Breach b
JOIN Position p
  ON b.userID = p.userID
 AND b.commodityCode = p.commodityCode
 AND b.exchangeCode = p.exchangeCode
SET b.resolutionStatus = 'Auto-Resolved',
    b.resolutionDate = CURDATE()
WHERE b.resolutionStatus = 'Pending Review'
  AND ABS(p.quantity) <= 1000
  AND p.mtmValue >= -50000;

-- Delete a user, their transactions and positions
DELETE p, t, u
FROM User u
LEFT JOIN Position p ON p.userID = u.userID
LEFT JOIN `Transaction` t ON t.userID = u.userID
WHERE u.userID = 123;


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
SET lastLogin = NOW()
WHERE userID = '1'