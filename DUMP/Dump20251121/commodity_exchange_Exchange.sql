-- MySQL dump 10.13  Distrib 8.0.44, for macos15 (arm64)
--
-- Host: 127.0.0.1    Database: commodity_exchange
-- ------------------------------------------------------
-- Server version	9.5.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '44016744-c0b1-11f0-bc9c-88614b54c2d4:1-924';

--
-- Table structure for table `Exchange`
--

DROP TABLE IF EXISTS `Exchange`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Exchange` (
  `exchangeCode` char(5) NOT NULL,
  `exchangeName` varchar(100) NOT NULL,
  `location` varchar(100) DEFAULT NULL,
  `description` varchar(300) DEFAULT NULL,
  `currencyCode` char(3) NOT NULL,
  PRIMARY KEY (`exchangeCode`),
  UNIQUE KEY `exchangeName` (`exchangeName`),
  KEY `currencyCode` (`currencyCode`),
  CONSTRAINT `exchange_ibfk_1` FOREIGN KEY (`currencyCode`) REFERENCES `Currency` (`currencyCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Exchange`
--

LOCK TABLES `Exchange` WRITE;
/*!40000 ALTER TABLE `Exchange` DISABLE KEYS */;
INSERT INTO `Exchange` VALUES ('CME','Chicago Mercantile Exchange','Chicago, USA','Major U.S. exchange for energy, metals, agriculture, and livestock futures.','USD'),('DCE','Dalian Commodity Exchange','Dalian, China','Large Chinese exchange focused on iron ore, soybeans, and agricultural futures.','CNY'),('DME','Dubai Mercantile Exchange','Dubai, United Arab Emirates','Key Middle Eastern exchange known for Oman crude oil futures.','USD'),('ICEEU','Intercontinental Exchange Europe','London, United Kingdom','Major exchange for Brent crude oil and soft commodities such as cocoa and sugar.','GBP'),('MCX','Multi Commodity Exchange of India','Mumbai, India','India’s largest commodity futures exchange for metals, energy, and agriculture.','INR'),('NYMEX','New York Mercantile Exchange','New York, USA','Key global marketplace for crude oil, natural gas, and precious metals.','USD'),('QME','Qatar Metals Exchange','Doha, Qatar','Regional exchange specializing in aluminum, steel, and LNG derivatives.','AED'),('SAFEX','South African Futures Exchange','Johannesburg, South Africa','Major African commodity exchange focused on agricultural contracts like maize and wheat.','ZAR'),('SCE','Saudi Commodities Exchange','Riyadh, Saudi Arabia','Major Saudi exchange specializing in crude oil benchmarks, metals, and agricultural products such as dates.','SAR'),('SFE','Sydney Futures Exchange','Sydney, Australia','Australian exchange historically active in commodities and financial derivatives.','AUD'),('TOCOM','Tokyo Commodity Exchange','Tokyo, Japan','Japan’s primary commodities exchange trading gold, rubber, and petroleum.','JPY'),('ZCE','Zhengzhou Commodity Exchange','Zhengzhou, China','Agricultural-focused exchange specializing in wheat, cotton, and sugar.','CNY');
/*!40000 ALTER TABLE `Exchange` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-21 16:44:00
