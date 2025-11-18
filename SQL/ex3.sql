
-- Currency Insertion

INSERT INTO Currency (currencyCode, currencyName, price, conversionRate)
VALUES 
('USD', 'US Dollar', 1.00, 1.00),
('CAD', 'Canadian Dollar', 1.00, 0.65);

SELECT * FROM Currency;

-- Exhange Insertion


INSERT INTO Exchange (exchangeCode, exchangeName, location, description, currencyCode)
VALUES
('NYME', 'New York Mercantile Exchange', 'New York, USA', 'Energy commodities exchange', 'USD'),
('TCE', 'Toronto Commodities Exchange', 'Toronto, Canada', 'Agriculture and metals exchange', 'CAD');

SELECT * FROM Exchange;


-- Commodity Insertion

INSERT INTO Commodity (commodityCode, fullName, type, unitOfMeasure, description)
VALUES
('COI', 'Crude Oil', 'Energy', 'Barrel', 'Standard Intermediate Crude Oil'),
('GOL', 'Gold', 'Metal', 'Ounce', 'Standard 24K gold futures contract');

SELECT * FROM Commodity;

-- MARKET PRICE INSERTION

INSERT INTO MarketPrice (
  priceDate,
  contractMonth,
  settlementPrice,
  bidPrice,
  askPrice,
  volume,
  source,
  commodityCode,
  exchangeCode
)
SELECT
  CURDATE(),
  'DEC2025',
  84.92,                
  84.60,                
  85.10,                
  2175,                 
  'ICE Feed',
  c.commodityCode,
  e.exchangeCode
FROM Commodity c
JOIN Exchange e
WHERE LOWER(c.fullName) LIKE '%crude oil%'                  
  AND LOWER(e.location) LIKE '%new york%';

SELECT * FROM MarketPrice;

-- USER INSERTION

INSERT INTO User (userEmail, firstName, lastName, role, createdDate, lastLogin)
VALUES 
('bgros@uwo.ca', 'Ben', 'Gros', 'Trader', CURDATE(), Null);

SELECT * FROM User;

-- TRANASCTION INSERTION

INSERT INTO `Transaction` (
  transactionDate,
  contractMonth,
  buySell,
  quantity,
  price,
  userID,
  commodityCode,
  exchangeCode,
  priceDate
)
VALUES (
  CURDATE(),
  'DEC2025',
  'Buy',
  250,
  (SELECT settlementPrice
     FROM MarketPrice
     WHERE commodityCode = 'COI'
       AND exchangeCode = 'NYME'
     ORDER BY priceDate DESC
     LIMIT 1),
  1,         -- Trader Sarah
  'COI',
  'NYME',
  CURDATE()
);

-- POSITION INSERTION

INSERT INTO Position (
  avgPrice,
  mtmValue,
  quantity,
  lastUpdated,
  userID,
  commodityCode,
  exchangeCode
)
SELECT *
FROM (
  SELECT
    ROUND(
      SUM(t.price *
          CASE 
            WHEN t.buySell = 'Buy'  THEN t.quantity
            WHEN t.buySell = 'Sell' THEN -t.quantity
          END
      ) / NULLIF(SUM(
          CASE 
            WHEN t.buySell = 'Buy'  THEN t.quantity
            WHEN t.buySell = 'Sell' THEN -t.quantity
          END
      ), 0), 2
    ) AS avgPrice,

    ROUND(
      (MAX(mp.settlementPrice) - 
        ROUND(
          SUM(t.price *
              CASE 
                WHEN t.buySell = 'Buy'  THEN t.quantity
                WHEN t.buySell = 'Sell' THEN -t.quantity
              END
          ) / NULLIF(SUM(
              CASE 
                WHEN t.buySell = 'Buy'  THEN t.quantity
                WHEN t.buySell = 'Sell' THEN -t.quantity
              END
          ), 0), 2)
      ) *
      SUM(
        CASE 
          WHEN t.buySell = 'Buy'  THEN t.quantity
          WHEN t.buySell = 'Sell' THEN -t.quantity
        END
      ), 2
    ) AS mtmValue,

    SUM(
      CASE 
        WHEN t.buySell = 'Buy'  THEN t.quantity
        WHEN t.buySell = 'Sell' THEN -t.quantity
      END
    ) AS quantity,

    CURDATE() AS lastUpdated,
    t.userID,
    t.commodityCode,
    t.exchangeCode
  FROM `Transaction` t
  JOIN MarketPrice mp
    ON t.commodityCode = mp.commodityCode
   AND t.exchangeCode = mp.exchangeCode
   AND t.priceDate = mp.priceDate
  GROUP BY t.userID, t.commodityCode, t.exchangeCode
  HAVING SUM(
           CASE 
             WHEN t.buySell = 'Buy'  THEN t.quantity
             WHEN t.buySell = 'Sell' THEN -t.quantity
           END
         ) <> 0
) AS new
ON DUPLICATE KEY UPDATE
  avgPrice   = new.avgPrice,
  mtmValue   = new.mtmValue,
  quantity   = new.quantity,
  lastUpdated = new.lastUpdated;

SELECT * FROM Position;


-- BREACH INSERTION

INSERT INTO Breach (
  breachDate,
  resolutionStatus,
  commodityCode,
  exchangeCode,
  userID
)
SELECT
  CURDATE() AS breachDate,
  'Pending Review' AS resolutionStatus,
  p.commodityCode,
  p.exchangeCode,
  p.userID
FROM Position p
WHERE ABS(p.quantity) > 1000
   OR p.mtmValue < -50000;  
   
SELECT * FROM Breach;