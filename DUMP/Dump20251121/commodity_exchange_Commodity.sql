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
-- Table structure for table `Commodity`
--

DROP TABLE IF EXISTS `Commodity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Commodity` (
  `commodityCode` char(5) NOT NULL,
  `fullName` varchar(100) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `unitOfMeasure` varchar(50) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`commodityCode`),
  UNIQUE KEY `description` (`description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Commodity`
--

LOCK TABLES `Commodity` WRITE;
/*!40000 ALTER TABLE `Commodity` DISABLE KEYS */;
INSERT INTO `Commodity` VALUES ('BRN','Brent Crude','Energy','Barrel','North Sea Brent crude benchmark used as a global oil price reference.'),('COF','Coffee','Agriculture','Pound','Arabica coffee futures commonly traded for global beverage and food industries.'),('COI','Crude Oil','Energy','Barrel','Standard intermediate crude oil benchmark traded globally.'),('COP','Copper','Metal','Pound','High-grade copper traded globally for industrial use.'),('CRN','Corn','Agriculture','Bushel','Yellow corn futures contract used widely in agriculture and biofuel.'),('GOL','Gold','Metal','Ounce','24-karat gold futures contract commonly used as a safe-haven asset.'),('LTH','Lithium','Metal','Metric Ton','Lithium carbonate used heavily in battery production for electric vehicles and portable electronics.'),('NGS','Natural Gas','Energy','MMBtu','Natural gas futures contract traded heavily in energy markets.'),('SBN','Soybeans','Agriculture','Bushel','Soybean futures contract traded across major agricultural exchanges.'),('SLV','Silver','Metal','Ounce','Physical silver futures widely used in industrial and investment markets.'),('SUG','Sugar','Agriculture','Pound','World Sugar No.11 futures contract used in global sugar markets.'),('WTW','Wheat','Agriculture','Bushel','Soft red winter wheat futures contract used in food and feed markets.');
/*!40000 ALTER TABLE `Commodity` ENABLE KEYS */;
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
