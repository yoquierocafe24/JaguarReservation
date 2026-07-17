CREATE DATABASE  IF NOT EXISTS `jaguar_reserva` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `jaguar_reserva`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: jaguar_reserva
-- ------------------------------------------------------
-- Server version	8.0.46

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

--
-- Table structure for table `administrador`
--

DROP TABLE IF EXISTS `administrador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administrador` (
  `id_admin` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  PRIMARY KEY (`id_admin`),
  UNIQUE KEY `correo` (`correo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administrador`
--

LOCK TABLES `administrador` WRITE;
/*!40000 ALTER TABLE `administrador` DISABLE KEYS */;
/*!40000 ALTER TABLE `administrador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asistencia`
--

DROP TABLE IF EXISTS `asistencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asistencia` (
  `id_asistencia` int NOT NULL AUTO_INCREMENT,
  `id_reserva` varchar(10) NOT NULL,
  `id_estudiante` int NOT NULL,
  `tipo_asistencia` enum('titular','acompanante','integrante','visitante') NOT NULL,
  `hora_entrada` time NOT NULL,
  `id_guardia` int NOT NULL,
  PRIMARY KEY (`id_asistencia`),
  KEY `id_reserva` (`id_reserva`),
  KEY `id_estudiante` (`id_estudiante`),
  KEY `id_guardia` (`id_guardia`),
  CONSTRAINT `asistencia_ibfk_1` FOREIGN KEY (`id_reserva`) REFERENCES `reservas` (`id_reserva`),
  CONSTRAINT `asistencia_ibfk_2` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`),
  CONSTRAINT `asistencia_ibfk_3` FOREIGN KEY (`id_guardia`) REFERENCES `guardia` (`id_guardia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asistencia`
--

LOCK TABLES `asistencia` WRITE;
/*!40000 ALTER TABLE `asistencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `asistencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calendario_bloqueos`
--

DROP TABLE IF EXISTS `calendario_bloqueos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `calendario_bloqueos` (
  `id_bloqueo` int NOT NULL AUTO_INCREMENT,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `motivo` varchar(255) DEFAULT NULL,
  `origen` enum('manual','google_calendar') DEFAULT 'manual',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_bloqueo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calendario_bloqueos`
--

LOCK TABLES `calendario_bloqueos` WRITE;
/*!40000 ALTER TABLE `calendario_bloqueos` DISABLE KEYS */;
/*!40000 ALTER TABLE `calendario_bloqueos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipo_integrantes`
--

DROP TABLE IF EXISTS `equipo_integrantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipo_integrantes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_equipo` int NOT NULL,
  `id_estudiante` int NOT NULL,
  `rol` enum('lider','sublider','jugador') NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `id_equipo` (`id_equipo`),
  KEY `id_estudiante` (`id_estudiante`),
  CONSTRAINT `equipo_integrantes_ibfk_1` FOREIGN KEY (`id_equipo`) REFERENCES `equipos` (`id_equipo`),
  CONSTRAINT `equipo_integrantes_ibfk_2` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipo_integrantes`
--

LOCK TABLES `equipo_integrantes` WRITE;
/*!40000 ALTER TABLE `equipo_integrantes` DISABLE KEYS */;
/*!40000 ALTER TABLE `equipo_integrantes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `equipos`
--

DROP TABLE IF EXISTS `equipos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipos` (
  `id_equipo` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `deporte` varchar(50) NOT NULL,
  `id_lider` int NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_equipo`),
  KEY `id_lider` (`id_lider`),
  CONSTRAINT `equipos_ibfk_1` FOREIGN KEY (`id_lider`) REFERENCES `estudiantes` (`id_estudiante`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipos`
--

LOCK TABLES `equipos` WRITE;
/*!40000 ALTER TABLE `equipos` DISABLE KEYS */;
/*!40000 ALTER TABLE `equipos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `espacios`
--

DROP TABLE IF EXISTS `espacios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `espacios` (
  `id_espacio` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `disponible` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_espacio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `espacios`
--

LOCK TABLES `espacios` WRITE;
/*!40000 ALTER TABLE `espacios` DISABLE KEYS */;
/*!40000 ALTER TABLE `espacios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estudiantes`
--

DROP TABLE IF EXISTS `estudiantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estudiantes` (
  `id_estudiante` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `dni` varchar(20) NOT NULL,
  `cuenta` varchar(30) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_estudiante`),
  UNIQUE KEY `dni` (`dni`),
  UNIQUE KEY `cuenta` (`cuenta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estudiantes`
--

LOCK TABLES `estudiantes` WRITE;
/*!40000 ALTER TABLE `estudiantes` DISABLE KEYS */;
/*!40000 ALTER TABLE `estudiantes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guardia`
--

DROP TABLE IF EXISTS `guardia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guardia` (
  `id_guardia` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  PRIMARY KEY (`id_guardia`),
  UNIQUE KEY `usuario` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guardia`
--

LOCK TABLES `guardia` WRITE;
/*!40000 ALTER TABLE `guardia` DISABLE KEYS */;
/*!40000 ALTER TABLE `guardia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horarios`
--

DROP TABLE IF EXISTS `horarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horarios` (
  `id_horario` int NOT NULL AUTO_INCREMENT,
  `id_espacio` int NOT NULL,
  `dia_semana` tinyint NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_horario`),
  KEY `id_espacio` (`id_espacio`),
  CONSTRAINT `horarios_ibfk_1` FOREIGN KEY (`id_espacio`) REFERENCES `espacios` (`id_espacio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios`
--

LOCK TABLES `horarios` WRITE;
/*!40000 ALTER TABLE `horarios` DISABLE KEYS */;
/*!40000 ALTER TABLE `horarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventario`
--

DROP TABLE IF EXISTS `inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventario` (
  `id_item` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `categoria` varchar(50) DEFAULT NULL,
  `cantidad_total` int DEFAULT '1',
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventario`
--

LOCK TABLES `inventario` WRITE;
/*!40000 ALTER TABLE `inventario` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reserva_acompanantes`
--

DROP TABLE IF EXISTS `reserva_acompanantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reserva_acompanantes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_reserva` varchar(10) NOT NULL,
  `id_estudiante` int NOT NULL,
  `confirmado` tinyint(1) DEFAULT '1',
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_reserva` (`id_reserva`),
  KEY `id_estudiante` (`id_estudiante`),
  CONSTRAINT `reserva_acompanantes_ibfk_1` FOREIGN KEY (`id_reserva`) REFERENCES `reservas` (`id_reserva`),
  CONSTRAINT `reserva_acompanantes_ibfk_2` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reserva_acompanantes`
--

LOCK TABLES `reserva_acompanantes` WRITE;
/*!40000 ALTER TABLE `reserva_acompanantes` DISABLE KEYS */;
/*!40000 ALTER TABLE `reserva_acompanantes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reserva_visitantes`
--

DROP TABLE IF EXISTS `reserva_visitantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reserva_visitantes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_reserva` varchar(10) NOT NULL,
  `id_estudiante` int NOT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_reserva` (`id_reserva`),
  KEY `id_estudiante` (`id_estudiante`),
  CONSTRAINT `reserva_visitantes_ibfk_1` FOREIGN KEY (`id_reserva`) REFERENCES `reservas` (`id_reserva`),
  CONSTRAINT `reserva_visitantes_ibfk_2` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reserva_visitantes`
--

LOCK TABLES `reserva_visitantes` WRITE;
/*!40000 ALTER TABLE `reserva_visitantes` DISABLE KEYS */;
/*!40000 ALTER TABLE `reserva_visitantes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservas`
--

DROP TABLE IF EXISTS `reservas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservas` (
  `id_reserva` varchar(10) NOT NULL,
  `id_estudiante` int NOT NULL,
  `id_espacio` int DEFAULT NULL,
  `id_item` int DEFAULT NULL,
  `tipo_reserva` enum('individual','equipo') DEFAULT 'individual',
  `id_equipo` int DEFAULT NULL,
  `fecha` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `solicitud_especial` varchar(255) DEFAULT NULL,
  `cant_acompanantes` int DEFAULT '0',
  `estado` enum('pendiente','aprobada','rechazada','cancelada') DEFAULT 'pendiente',
  `cancelado_por` enum('estudiante','admin') DEFAULT NULL,
  `qr_token` varchar(255) DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_reserva`),
  UNIQUE KEY `qr_token` (`qr_token`),
  KEY `id_estudiante` (`id_estudiante`),
  KEY `id_espacio` (`id_espacio`),
  KEY `id_item` (`id_item`),
  KEY `id_equipo` (`id_equipo`),
  CONSTRAINT `reservas_ibfk_1` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`),
  CONSTRAINT `reservas_ibfk_2` FOREIGN KEY (`id_espacio`) REFERENCES `espacios` (`id_espacio`),
  CONSTRAINT `reservas_ibfk_3` FOREIGN KEY (`id_item`) REFERENCES `inventario` (`id_item`),
  CONSTRAINT `reservas_ibfk_4` FOREIGN KEY (`id_equipo`) REFERENCES `equipos` (`id_equipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservas`
--

LOCK TABLES `reservas` WRITE;
/*!40000 ALTER TABLE `reservas` DISABLE KEYS */;
/*!40000 ALTER TABLE `reservas` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-16 19:57:36
