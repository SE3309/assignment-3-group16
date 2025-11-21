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
-- Table structure for table `Currency`
--

DROP TABLE IF EXISTS `Currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Currency` (
  `currencyCode` char(3) NOT NULL,
  `currencyName` varchar(50) NOT NULL,
  `price` decimal(12,2) DEFAULT NULL,
  `conversionRate` decimal(12,6) DEFAULT NULL,
  PRIMARY KEY (`currencyCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Currency`
--

LOCK TABLES `Currency` WRITE;
/*!40000 ALTER TABLE `Currency` DISABLE KEYS */;
INSERT INTO `Currency` VALUES ('AED','United Arab Emirates Dirham',1.00,1.700000),('AUD','Australian Dollar',1.00,1.170000),('BRL','Brazilian Real',1.00,0.720000),('CAD','Canadian Dollar',1.00,0.680000),('CHF','Swiss Franc',1.00,1.080000),('CNY','Chinese Yuan',1.00,1.000000),('DKK','Danish Krone',1.00,0.880000),('EUR','Euro',1.00,1.070000),('GBP','British Pound Sterling',1.00,1.050000),('HKD','Hong Kong Dollar',1.00,1.080000),('INR','Indian Rupee',1.00,0.880000),('JPY','Japanese Yen',1.00,0.770000),('KRW','South Korean Won',1.00,1.200000),('MXN','Mexican Peso',1.00,1.220000),('NOK','Norwegian Krone',1.00,0.940000),('NZD','New Zealand Dollar',1.00,1.140000),('SAR','Saudi Riyal',1.00,2.100000),('SEK','Swedish Krona',1.00,0.440000),('SGD','Singapore Dollar',1.00,1.380000),('TRY','Turkish Lira',1.00,1.300000),('USD','US Dollar',1.00,0.960000),('ZAR','South African Rand',1.00,1.270000);
/*!40000 ALTER TABLE `Currency` ENABLE KEYS */;
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
