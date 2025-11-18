
-- Calculates every users trade quantity
SELECT userID,
       SUM(CASE WHEN buySell = 'Buy' THEN quantity ELSE -quantity END) AS netQuantity
FROM Transaction
GROUP BY userID
HAVING netQuantity != 0
LIMIT 10;

-- Find the commodity with the most breaches
SELECT 
    c.commodityCode,
    c.fullName,
    COUNT(*) AS totalBreaches
FROM Commodity c
JOIN Breach b
    ON b.commodityCode = c.commodityCode
GROUP BY c.commodityCode, c.fullName
ORDER BY totalBreaches DESC
LIMIT 1;

-- Compares users average price purchased to the current market price
SELECT u.firstName, u.lastName, p.commodityCode, p.exchangeCode,
       p.quantity, p.avgPrice, mp.settlementPrice
FROM Position p
JOIN User u 
  ON p.userID = u.userID
JOIN MarketPrice mp 
  ON p.commodityCode = mp.commodityCode
 AND p.exchangeCode = mp.exchangeCode
WHERE mp.priceDate = (
    SELECT MAX(priceDate)
    FROM MarketPrice
    WHERE commodityCode = p.commodityCode
      AND exchangeCode = p.exchangeCode
)
LIMIT 10;

-- 10 Highest Total MTM Value
SELECT 
    u.userID,
    u.firstName,
    u.lastName,
    SUM(p.mtmValue) AS totalTraderValue
FROM Position p
JOIN User u 
  ON p.userID = u.userID
GROUP BY u.userID, u.firstName, u.lastName
ORDER BY totalTraderValue DESC
LIMIT 10;


-- How much of each commodity was traded on the most recent days
SELECT 
    t.commodityCode,
    c.fullName,
    SUM(t.quantity) AS totalVolume
FROM Transaction t
JOIN Commodity c 
    ON t.commodityCode = c.commodityCode
WHERE t.transactionDate = (
    SELECT MAX(transactionDate)
    FROM Transaction
)
GROUP BY t.commodityCode, c.fullName
ORDER BY totalVolume DESC;

-- Find the commodity on exchange with best growth in the past week
SELECT 
    c.fullName AS commodityName,
    mp_recent.commodityCode,
    e.exchangeName,
    mp_recent.exchangeCode,
    (mp_recent.settlementPrice - mp_old.settlementPrice) AS growth
FROM MarketPrice mp_recent
JOIN MarketPrice mp_old
    ON mp_recent.commodityCode = mp_old.commodityCode
   AND mp_recent.exchangeCode = mp_old.exchangeCode
JOIN Commodity c
    ON mp_recent.commodityCode = c.commodityCode
JOIN Exchange e
    ON mp_recent.exchangeCode = e.exchangeCode
WHERE mp_recent.priceDate = (
        SELECT MAX(priceDate)
        FROM MarketPrice
    )
  AND mp_old.priceDate = (
        SELECT MAX(priceDate) - INTERVAL 7 DAY
        FROM MarketPrice
    )
ORDER BY growth DESC
LIMIT 1;

-- Commodities with the Most Price Volatility in the Past 30 Days
SELECT
    c.fullName AS commodityName,
    mp.commodityCode,
    mp.exchangeCode,
    MAX(mp.settlementPrice) - MIN(mp.settlementPrice) AS priceVolatility
FROM MarketPrice mp
WHERE mp.priceDate >= CURDATE() - INTERVAL 30 DAY
GROUP BY mp.commodityCode, mp.exchangeCode
ORDER BY priceVolatility DESC
LIMIT 10;
