
-- Currency Insertion

INSERT INTO Currency (currencyCode, currencyName, price, conversionRate)
VALUES 
('AED', 'United Arab Emirates Dirham', 1.00, 1.70),
('SAR', 'Saudi Riyal', 1.00, 2.1);

SELECT * FROM Currency;

-- Exhange Insertion


INSERT INTO Exchange (exchangeCode, exchangeName, location, description, currencyCode)
VALUES
('QME', 'Qatar Metals Exchange', 'Doha, Qatar', 'Regional exchange specializing in aluminum, steel, and LNG derivatives.', 'AED'),
('SCE', 'Saudi Commodities Exchange', 'Riyadh, Saudi Arabia', 'Major Saudi exchange specializing in crude oil benchmarks, metals, and agricultural products such as dates.', 'SAR');

SELECT * FROM Exchange;


-- Commodity Insertion

INSERT INTO Commodity (commodityCode, fullName, type, unitOfMeasure, description)
VALUES
('LTH', 'Lithium', 'Metal', 'Metric Ton', 'Lithium carbonate used heavily in battery production for electric vehicles and portable electronics.'),
('COF', 'Coffee', 'Agriculture', 'Pound', 'Arabica coffee futures commonly traded for global beverage and food industries.');

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
WHERE LOWER(c.fullName) LIKE '%coffee%'                  
  AND LOWER(e.location) LIKE '%doha%';

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
  10000,
  (SELECT settlementPrice
     FROM MarketPrice
     WHERE commodityCode = 'COF'
       AND exchangeCode = 'QME'
       AND priceDate <= CURDATE()
     ORDER BY priceDate DESC
     LIMIT 1),
  1,
  'COF',
  'QME',
  CURDATE()
);

SELECT * FROM Transaction;

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
WHERE (ABS(p.quantity) > 1000
   OR p.mtmValue < -50000)  
   AND NOT EXISTS (
      SELECT 1
      FROM Breach b
      WHERE b.userID = p.userID
      AND b.commodityCode = p.commodityCode
      AND b.exchangeCode = p.exchangeCode
      AND b.resolutionStatus = 'Pending Review');
   
SELECT * FROM Breach;