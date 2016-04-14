-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: orpas.cg27wrvn2c24.us-west-2.rds.amazonaws.com    Database: orpas
-- ------------------------------------------------------
-- Server version	5.6.23-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cadastro`
--

DROP TABLE IF EXISTS `cadastro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cadastro` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `rg` varchar(30) NOT NULL,
  `cpf` varchar(30) NOT NULL,
  `cartao` varchar(30) NOT NULL,
  `tipo` int(11) NOT NULL,
  `saldo` decimal(65,2) NOT NULL,
  `conta` varchar(30) NOT NULL,
  `senha` varchar(50) NOT NULL,
  `ultimo_id` int(10) unsigned NOT NULL,
  `ultimo_uso` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transfers`
--

DROP TABLE IF EXISTS `transfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transfers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `valor` decimal(65,2) unsigned NOT NULL,
  `origem` int(10) unsigned NOT NULL,
  `destino` int(10) unsigned NOT NULL,
  `data` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'orpas'
--
/*!50003 DROP PROCEDURE IF EXISTS `extrato` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orpas`@`%` PROCEDURE `extrato`(IN id_ INT(10) UNSIGNED)
BEGIN

	(SELECT 
		valor * (- 1) AS valor, cadastro.nome as nome, `data`
	FROM
		orpas.transfers
	INNER JOIN
		cadastro ON cadastro.id = transfers.destino
	WHERE
		origem = id_) 
	UNION 
	(SELECT 
		valor, cadastro.nome as nome, `data`
	FROM
		orpas.transfers
	INNER JOIN
		cadastro ON cadastro.id = transfers.origem
	WHERE
		destino = id_) 
	ORDER BY `data`;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `transfer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orpas`@`%` PROCEDURE `transfer`(IN valor_ DECIMAL(65,2), IN pagador_ INT(10) UNSIGNED, IN recebedor_ INT(10) UNSIGNED)
BEGIN

	CALL ver_saldo2(pagador_,@saldo);

	IF pagador_ = 0 THEN
		SELECT -2;
	ELSEIF recebedor_ = 0 THEN 
		SELECT -3;

	ELSEIF @saldo < valor_ THEN
		SELECT -1;
	ELSE
		INSERT INTO `orpas`.`transfers` (`valor`, `origem`, `destino`) VALUES (valor_, pagador_, recebedor_);
		CALL ver_saldo2(recebedor_,@saldo);
		UPDATE `orpas`.`cadastro` SET `saldo`=@saldo WHERE `id`=recebedor_;

		CALL ver_saldo2(pagador_,@saldo);
		UPDATE `orpas`.`cadastro` SET `saldo`=@saldo WHERE `id`=pagador_;

		SELECT valor_;
	END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ver_saldo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orpas`@`%` PROCEDURE `ver_saldo`(IN id_ INT(10) UNSIGNED, OUT saldo DECIMAL(65,2))
BEGIN

	SELECT cast(SUM(valor) as DECIMAL(65,2)) INTO @credito FROM orpas.transfers WHERE destino = id_;
	SELECT cast(SUM(valor) as DECIMAL(65,2)) INTO @debito FROM orpas.transfers WHERE origem = id_;

	SET saldo = COALESCE(@credito,0) - COALESCE(@debito,0);

	SELECT saldo;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ver_saldo2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`orpas`@`%` PROCEDURE `ver_saldo2`(IN id_ INT(10) UNSIGNED, OUT saldo DECIMAL(65,2))
BEGIN

	SELECT cast(SUM(valor) as DECIMAL(65,2) ) INTO @credito FROM orpas.transfers WHERE destino = id_;
	SELECT cast(SUM(valor) as DECIMAL(65,2) ) INTO @debito FROM orpas.transfers WHERE origem = id_;

	SET saldo = COALESCE(@credito,0) - COALESCE(@debito,0);

#	SELECT saldo;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-04-13 21:49:06
