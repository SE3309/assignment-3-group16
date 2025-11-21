
DROP VIEW IF EXISTS CommodityPrices;

-- Gets the lastest price of every commodity exchange pair
CREATE VIEW CommodityPrices AS
SELECT mp.*, Commodity.fullName, Exchange.exchangeName
FROM MarketPrice mp
JOIN (
    SELECT commodityCode, exchangeCode, MAX(priceDate) AS latestDate
    FROM MarketPrice
    GROUP BY commodityCode, exchangeCode
) AS latest
  ON mp.commodityCode = latest.commodityCode
 AND mp.exchangeCode = latest.exchangeCode
 AND mp.priceDate = latest.latestDate
JOIN Commodity
ON Commodity.commodityCode = mp.commodityCode
JOIN Exchange
ON Exchange.exchangeCode = mp.exchangeCode;

SELECT * FROM CommodityPrices LIMIT 5;

 -- INSERT INTO CommodityPrices (
--     priceDate,
--     contractMonth,
--     settlementPrice,
--     bidPrice,
--     askPrice,
--     volume,
--     source,
--     commodityCode,
--     exchangeCode
-- ) VALUES (
--     '2025-11-21',
--     'DEC2025',
--     40.33,
--     39.94,
--     40.74,
--     303,
--     'Simulated Feed',
--     'BRN',
--     'DCE'
-- );


DROP VIEW IF EXISTS FastestGrowingCommodities;

-- Find the commodities with the fastest growth month over month
CREATE VIEW FastestGrowingCommodities AS
SELECT
    recent.commodityCode,
    recent.exchangeCode,
    recent.avgPrice AS currentPrice,
    prev.avgPrice AS previousPrice,
    ((recent.avgPrice - prev.avgPrice) / prev.avgPrice) * 100 AS growthRate
FROM
    (
        SELECT
            commodityCode,
            exchangeCode,
            AVG(settlementPrice) AS avgPrice
        FROM MarketPrice
        WHERE priceDate >= CURRENT_DATE - INTERVAL 30 DAY
        GROUP BY commodityCode, exchangeCode
    ) AS recent
JOIN
    (
        SELECT
            commodityCode,
            exchangeCode,
            AVG(settlementPrice) AS avgPrice
        FROM MarketPrice
        WHERE priceDate < CURRENT_DATE - INTERVAL 30 DAY
          AND priceDate >= CURRENT_DATE - INTERVAL 60 DAY
        GROUP BY commodityCode, exchangeCode
    ) AS prev
ON recent.commodityCode = prev.commodityCode
AND recent.exchangeCode = prev.exchangeCode
ORDER BY growthRate DESC;

SELECT * FROM FastestGrowingCommodities LIMIT 5;

-- UPDATE FastestGrowingCommodities
-- SET currentPrice=600, previousPrice=300, growthRate=70
-- WHERE commodityCode='SBN'
-- AND exchangeCode='NYMEX'
