-- ======================================================
-- Base de Datos para u692901087_cdelu3
-- Optimizada para importación manual en MySQL/phpMyAdmin
-- Sincronizada con backup del 30-03-2026 y u692901087_cdelu3
-- ======================================================

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Estructura de base de datos
CREATE DATABASE IF NOT EXISTS `u692901087_cdelu3`;
USE `u692901087_cdelu3`;

-- ------------------------------------------------------
-- 1. Tablas de Configuración y Sistema
-- ------------------------------------------------------

DROP TABLE IF EXISTS `admin_settings`;
CREATE TABLE `admin_settings` (
  `key` varchar(100) NOT NULL,
  `value` text NOT NULL,
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `system_modules`;
CREATE TABLE `system_modules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `module_name` varchar(50) NOT NULL,
  `display_name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `module_name` (`module_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ------------------------------------------------------
-- 2. Gestión de Usuarios y Roles
-- ------------------------------------------------------

DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT 0,
  `profile_picture_url` varchar(500) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `user_follows`;
CREATE TABLE `user_follows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `follower_id` int(11) NOT NULL,
  `following_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_follow` (`follower_id`,`following_id`),
  KEY `idx_follower` (`follower_id`),
  KEY `idx_following` (`following_id`),
  CONSTRAINT `user_follows_ibfk_1` FOREIGN KEY (`follower_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_follows_ibfk_2` FOREIGN KEY (`following_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ------------------------------------------------------
-- 3. Publicidad
-- ------------------------------------------------------

DROP TABLE IF EXISTS `ads`;
CREATE TABLE `ads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `enlace_destino` varchar(500) NOT NULL,
  `texto_opcional` varchar(255) DEFAULT NULL,
  `categoria` varchar(100) DEFAULT 'general',
  `prioridad` int(11) DEFAULT 1,
  `activo` tinyint(1) DEFAULT 1,
  `impresiones_maximas` int(11) DEFAULT 0,
  `impresiones_actuales` int(11) DEFAULT 0,
  `clics_count` int(11) DEFAULT 0,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `ads_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ------------------------------------------------------
-- 4. Comunidad y Feed
-- ------------------------------------------------------

DROP TABLE IF EXISTS `com`;
CREATE TABLE `com` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) NOT NULL,
  `descripcion` text NOT NULL,
  `video_url` varchar(500) DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `com_comments`;
CREATE TABLE `com_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `com_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `com_id` (`com_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `com_likes`;
CREATE TABLE `com_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `com_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_like` (`com_id`,`user_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `content_feed`;
CREATE TABLE `content_feed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_type` enum('news','community') NOT NULL,
  `reference_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `video_url` varchar(500) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `user_profile_picture` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_content_type` (`content_type`),
  KEY `idx_reference_id` (`reference_id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `content_comments`;
CREATE TABLE `content_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `feed_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_feed_id` (`feed_id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `content_comments_ibfk_1` FOREIGN KEY (`feed_id`) REFERENCES `content_feed` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `content_likes`;
CREATE TABLE `content_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` int(11) NOT NULL COMMENT 'ID del contenido en content_feed',
  `user_id` int(11) NOT NULL COMMENT 'ID del usuario que dio like',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_content` (`user_id`,`content_id`),
  KEY `idx_content_id` (`content_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------
-- 5. Noticias
-- ------------------------------------------------------

DROP TABLE IF EXISTS `news`;
CREATE TABLE `news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) NOT NULL,
  `descripcion` text NOT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `image_thumbnail_url` text DEFAULT NULL,
  `diario` varchar(100) DEFAULT NULL,
  `categoria` varchar(100) DEFAULT NULL,
  `original_url` varchar(500) DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `is_oficial` tinyint(1) DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `news_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `news_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `news_id` (`news_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `likes`;
CREATE TABLE `likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `news_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_news_like` (`news_id`,`user_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------
-- 6. Loterías
-- ------------------------------------------------------

DROP TABLE IF EXISTS `lotteries`;
CREATE TABLE `lotteries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `max_tickets` int(11) NOT NULL,
  `ticket_price` decimal(10,2) DEFAULT 0.00,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `status` enum('pending','active','closed','cancelled') DEFAULT 'pending',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `lottery_settings`;
CREATE TABLE `lottery_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL COMMENT 'Clave de configuración',
  `setting_value` text COMMENT 'Valor de configuración',
  `description` varchar(255) DEFAULT NULL COMMENT 'Descripción',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_setting_key` (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `lottery_reserved_numbers`;
CREATE TABLE `lottery_reserved_numbers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lottery_id` int(11) NOT NULL,
  `ticket_number` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `reserved_at` datetime DEFAULT current_timestamp(),
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_lottery_number` (`lottery_id`,`ticket_number`),
  KEY `idx_lottery_id` (`lottery_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `lottery_tickets`;
CREATE TABLE `lottery_tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lottery_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `ticket_number` int(11) NOT NULL,
  `purchase_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `payment_status` enum('pending','paid','failed','refunded') NOT NULL DEFAULT 'pending',
  `payment_amount` decimal(10,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_lottery_ticket` (`lottery_id`,`ticket_number`),
  KEY `idx_lottery_id` (`lottery_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `lottery_winners`;
CREATE TABLE `lottery_winners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lottery_id` int(11) NOT NULL,
  `ticket_id` int(11) NOT NULL,
  `user_id visitor_id` int(11) NOT NULL,
  `ticket_number` int(11) NOT NULL,
  `prize_description` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_lottery_winner` (`lottery_id`,`ticket_id`),
  KEY `idx_lottery_id` (`lottery_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------
-- 7. Encuestas
-- ------------------------------------------------------

DROP TABLE IF EXISTS `surveys`;
CREATE TABLE `surveys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `question` text NOT NULL,
  `status` enum('active','inactive','completed') DEFAULT 'active',
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `survey_options`;
CREATE TABLE `survey_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) NOT NULL,
  `option_text` varchar(500) NOT NULL,
  `votes_count` int(11) DEFAULT 0,
  `display_order` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_survey_id` (`survey_id`),
  CONSTRAINT `survey_options_ibfk_1` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `survey_stats`;
CREATE TABLE `survey_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) NOT NULL,
  `total_votes` int(11) DEFAULT 0,
  `unique_voters` int(11) DEFAULT 0,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_survey_stats` (`survey_id`),
  CONSTRAINT `survey_stats_ibfk_1` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `survey_votes`;
CREATE TABLE `survey_votes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) NOT NULL,
  `option_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_ip` varchar(45) DEFAULT NULL,
  `voted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_survey_id` (`survey_id`),
  KEY `idx_option_id` (`option_id`),
  CONSTRAINT `survey_votes_ibfk_1` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE,
  CONSTRAINT `survey_votes_ibfk_2` FOREIGN KEY (`option_id`) REFERENCES `survey_options` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------
-- 8. Disparadores (Triggers)
-- ------------------------------------------------------

DELIMITER ;;

-- Sincronización de Comunidad a Feed
DROP TRIGGER IF EXISTS `after_com_insert`;;
CREATE TRIGGER `after_com_insert` AFTER INSERT ON `com` FOR EACH ROW
BEGIN
    DECLARE user_name_val VARCHAR(100);
    DECLARE user_pic_val VARCHAR(500);
    
    SELECT nombre, profile_picture_url INTO user_name_val, user_pic_val 
    FROM users WHERE id = NEW.user_id;
    
    INSERT INTO content_feed (
        content_type, reference_id, title, description, 
        image_url, video_url, user_id, user_name, 
        user_profile_picture, created_at
    ) VALUES (
        'community', NEW.id, NEW.titulo, NEW.descripcion, 
        NEW.image_url, NEW.video_url, NEW.user_id, user_name_val, 
        user_pic_val, NEW.created_at
    );
END;;

-- Sincronización de Noticias a Feed
DROP TRIGGER IF EXISTS `after_news_insert`;;
CREATE TRIGGER `after_news_insert` AFTER INSERT ON `news` FOR EACH ROW
BEGIN
    INSERT INTO content_feed (
        content_type, reference_id, title, description, 
        image_url, user_id, user_name, created_at
    ) VALUES (
        'news', NEW.id, NEW.titulo, NEW.descripcion, 
        NEW.image_url, NEW.created_by, 'Admin Oficial', NEW.created_at
    );
END;;

-- Sincronización de actualización de usuario
DROP TRIGGER IF EXISTS `after_user_update`;;
CREATE TRIGGER `after_user_update` AFTER UPDATE ON `users` FOR EACH ROW
BEGIN
  IF OLD.nombre != NEW.nombre OR OLD.profile_picture_url != NEW.profile_picture_url THEN
    UPDATE content_feed 
    SET user_name = NEW.nombre, user_profile_picture = NEW.profile_picture_url
    WHERE user_id = NEW.id;
  END IF;
END;;

-- Sincronización de borrado de COM
DROP TRIGGER IF EXISTS `after_com_delete`;;
CREATE TRIGGER `after_com_delete` AFTER DELETE ON `com` FOR EACH ROW
BEGIN
    DELETE FROM content_feed WHERE content_type = 'community' AND reference_id = OLD.id;
END;;

-- Inicialización automática de estadísticas de encuesta
DROP TRIGGER IF EXISTS `create_survey_stats`;;
CREATE TRIGGER `create_survey_stats` AFTER INSERT ON `surveys` FOR EACH ROW
BEGIN
    INSERT INTO survey_stats (survey_id, total_votes, unique_voters)
    VALUES (NEW.id, 0, 0);
END;;

DELIMITER ;

-- ------------------------------------------------------
-- 9. Datos Iniciales (Seeds)
-- ------------------------------------------------------

-- Roles del Sistema
INSERT INTO `roles` (`id`, `name`) VALUES 
(1, 'administrador'),
(2, 'colaborador'),
(3, 'usuario')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- Módulos del Sistema
INSERT INTO `system_modules` (`module_name`, `display_name`, `description`, `enabled`) VALUES 
('ads', 'Publicidad', 'Gestión de banners publicitarios', 1),
('lotteries', 'Sorteos', 'Sistema de loterías y tickets', 1),
('surveys', 'Encuestas', 'Sistema de votación y encuestas', 1),
('community', 'Comunidad', 'Feed de publicaciones de usuarios', 1),
('news', 'Noticias', 'Portal de noticias oficiales', 1)
ON DUPLICATE KEY UPDATE enabled=VALUES(enabled);

-- Configuración Básica
INSERT INTO `admin_settings` (`key`, `value`) VALUES 
('auto_backup_enabled', 'true'),
('video_settings', '{\"isVideoEnabled\":false}')
ON DUPLICATE KEY UPDATE value=VALUES(value);

-- Configuración de Lotería
INSERT INTO `lottery_settings` (`setting_key`, `setting_value`, `description`) VALUES
('reservation_timeout', '300', 'Tiempo de reserva de números en segundos (5 minutos)'),
('max_tickets_per_user', '10', 'Máximo número de tickets por usuario por lotería'),
('auto_close_enabled', '1', 'Habilitar cierre automático de loterías'),
('notification_email', 'admin@cdelu.ar', 'Email para notificaciones de lotería'),
('default_currency', 'ARS', 'Moneda por defecto para loterías de pago')
ON DUPLICATE KEY UPDATE setting_value=VALUES(setting_value);

-- Usuario Administrador Principal
-- Pass: @35115415
INSERT INTO `users` (`id`, `nombre`, `email`, `username`, `password`, `role_id`) VALUES 
(1, 'Matias Administrador', 'matias4315@gmail.com', 'admin', '$2a$10$QYVHmSOXyhJkpMHm2NErWOczuquqqwJ8EQrM2p73p8a7bxZSqMDja', 1)
ON DUPLICATE KEY UPDATE email=VALUES(email);

-- Finalización del Script de Base de Datos
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT;
SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS;
SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION;
SET TIME_ZONE=@OLD_TIME_ZONE;
