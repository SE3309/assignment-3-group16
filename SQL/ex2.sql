DROP DATABASE IF EXISTS commodity_exchange;
CREATE DATABASE commodity_exchange;
USE commodity_exchange;

-- 1. Currency
CREATE TABLE Currency (
  currencyCode CHAR(3) PRIMARY KEY,
  currencyName VARCHAR(50) NOT NULL,
  price DECIMAL(12,2),
  conversionRate DECIMAL(12,6)
);

DESCRIBE Currency;

-- 2. Exchange
CREATE TABLE Exchange (
  exchangeCode CHAR(5) PRIMARY KEY,
  exchangeName VARCHAR(100) NOT NULL UNIQUE,
  location VARCHAR(100),
  description TEXT,
  currencyCode CHAR(3) NOT NULL,
  FOREIGN KEY (currencyCode) REFERENCES Currency(currencyCode)
);

DESCRIBE exchange;

-- 3. Commodity
CREATE TABLE Commodity (
  commodityCode CHAR(5) PRIMARY KEY,
  fullName VARCHAR(100) NOT NULL,
  type VARCHAR(50),
  unitOfMeasure VARCHAR(50),
  description VARCHAR(200) UNIQUE
);

DESCRIBE Commodity;

-- 4. User
CREATE TABLE User (
  userID INT AUTO_INCREMENT PRIMARY KEY,
  userEmail VARCHAR(100) NOT NULL UNIQUE,
  firstName VARCHAR(50),
  lastName VARCHAR(50),
  role ENUM('Trader','Admin','Analyst', 'High Risk Trader') DEFAULT 'Trader',
  createdDate DATE,
  lastLogin DATETIME
);

-- 5. MarketPrice
CREATE TABLE MarketPrice (
  priceDate DATE,
  contractMonth VARCHAR(20),
  settlementPrice DECIMAL(12,2),
  bidPrice DECIMAL(12,2),
  askPrice DECIMAL(12,2),
  volume INT,
  source VARCHAR(100),
  commodityCode CHAR(5),
  exchangeCode CHAR(5),
  PRIMARY KEY (priceDate, commodityCode, exchangeCode),
  FOREIGN KEY (commodityCode) REFERENCES Commodity(commodityCode),
  FOREIGN KEY (exchangeCode) REFERENCES Exchange(exchangeCode)
);

-- 6. Transaction
CREATE TABLE Transaction (
  transactionNo INT AUTO_INCREMENT PRIMARY KEY,
  transactionDate DATE,
  contractMonth VARCHAR(20),
  buySell ENUM('Buy','Sell'),
  quantity INT,
  price DECIMAL(12,2),
  userID INT,
  commodityCode CHAR(5),
  exchangeCode CHAR(5),
  priceDate DATE,
  FOREIGN KEY (userID) REFERENCES User(userID),
  FOREIGN KEY (priceDate, commodityCode, exchangeCode) REFERENCES MarketPrice(priceDate, commodityCode, exchangeCode)
);

-- 7. Position
CREATE TABLE Position (
  avgPrice DECIMAL(12,2),
  mtmValue DECIMAL(12,2),
  quantity INT,
  lastUpdated DATE,
  userID INT,
  commodityCode CHAR(5),
  exchangeCode CHAR(5),
  PRIMARY KEY (commodityCode, exchangeCode, userID),
  FOREIGN KEY (userID) REFERENCES User(userID),
  FOREIGN KEY (commodityCode) REFERENCES Commodity(commodityCode),
  FOREIGN KEY (exchangeCode) REFERENCES Exchange(exchangeCode)
);

DESCRIBE Position;

-- 8. Breach
CREATE TABLE Breach (
  breachNo INT AUTO_INCREMENT PRIMARY KEY,
  breachDate DATE,
  resolutionStatus VARCHAR(100),
  commodityCode CHAR(5),
  exchangeCode CHAR(5),
  userID INT,
  FOREIGN KEY (commodityCode, exchangeCode, userID)
    REFERENCES `Position`(commodityCode, exchangeCode, userID)
);