import mysql.connector
import os
from dotenv import load_dotenv
from basic_generation import generate_currencies, generate_exchanges, generate_commodities
from user_generation import generate_users
from datetime import date
import time
from market_price_generation import simulate_all_prices
from transaction_generation import generate_transactions

load_dotenv()

connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password=os.getenv("DB_PASSWORD"),
    database="commodity_exchange"
)

cursor = connection.cursor(dictionary=True)

# cursor.execute('DELETE FROM Position')
# cursor.execute('DELETE FROM `Transaction`')
# cursor.execute('DELETE FROM MarketPrice')
# cursor.execute('DELETE FROM Exchange')
# cursor.execute('DELETE FROM Commodity')
# cursor.execute('DELETE FROM Currency')
# cursor.execute("DELETE FROM User")

connection.commit()

currencies = generate_currencies()
sql_command = """
INSERT INTO Currency (currencyCode, currencyName, price, conversionRate)
VALUES 
(%s, %s, %s, %s);
"""

values = [
    (c['currencyCode'], c['fullName'], c['price'], c['conversionRate'])
    for c in currencies
]

cursor.executemany(sql_command, values)
connection.commit()


exchanges = generate_exchanges()

sql_command = """
INSERT INTO Exchange (exchangeCode, exchangeName, location, description, currencyCode)
VALUES 
(%s, %s, %s, %s, %s);
"""

values = [
    (e['exchangeCode'], e['exchangeName'], e['location'], e['description'], e['currencyCode'])
    for e in exchanges
]

cursor.executemany(sql_command, values)
connection.commit()


commodities = generate_commodities()

sql_command = """
INSERT INTO Commodity (commodityCode, fullName, type, unitOfMeasure, description)
VALUES 
(%s, %s, %s, %s, %s);
"""

values = [
    (c['commodityCode'], c['fullName'], c['type'], c['unitOfMeasure'], c['description'])
    for c in commodities
]

cursor.executemany(sql_command, values)
connection.commit()


users = generate_users()

sql_command = """
INSERT INTO User (userEmail, firstName, lastName, role, createdDate, lastLogin)
VALUES 
(%s, %s, %s, %s, %s, %s);
"""

values = [
    (u['email'], u['firstName'], u['lastName'], u['role'], u['createdDate'], u['lastLogin'])
    for u in users
]

cursor.executemany(sql_command, values)
connection.commit()

price_time = time.time()

market_prices = simulate_all_prices()

sql_command = """
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
  %s,
  %s,
  %s,
  %s,
  %s,
  %s,
  %s,
  c.commodityCode,
  e.exchangeCode
FROM Commodity c
JOIN Exchange e
WHERE LOWER(c.fullName) LIKE %s
  AND LOWER(e.location) LIKE %s;
"""

values = [
    (m['priceDate'], m["contractMonth"], m["settlementPrice"], m['bidPrice'],
     m['askPrice'], m['volume'], m['source'], f"%{m['commodityCode'].lower()}%", f"%{m['exchange_location'].lower()}%")
    for m in market_prices
]

cursor.executemany(sql_command, values)
connection.commit()

print(f"Market Price Created: {round(time.time() - price_time,2)} Seconds")

transaction_time = time.time()

cursor.execute("SELECT * FROM User")
users = cursor.fetchall()

transactions = generate_transactions(users, date(2023,1,1), date(2025,11,1))

sql_command = """
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
  %s,
  %s,
  %s,
  %s,
  (SELECT settlementPrice
     FROM MarketPrice
     WHERE commodityCode = %s
       AND exchangeCode = %s
       AND priceDate <= %s
     ORDER BY priceDate DESC
     LIMIT 1),
  %s,         
  %s,
  %s,
  %s
);
"""

values = [
    (t['transactionDate'], t['contractMonth'], t['buySell'], t['quantity'],
     t['commodityCode'], t['exchangeCode'], t['priceDate'], t['userID'],
     t['commodityCode'], t['exchangeCode'], t['priceDate'])
    for t in transactions
]

cursor.executemany(sql_command, values)
connection.commit()

print(f"Transactions Generated: {round(time.time() - transaction_time,2)} Seconds")

position_time = time.time()

sql_command = """
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

"""

cursor.execute(sql_command)
connection.commit()

print(f"Positions Generated: {round(time.time() - position_time,2)} Seconds")


sql_command = """
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
"""

cursor.execute(sql_command)
connection.commit()

cursor.close()
connection.close()