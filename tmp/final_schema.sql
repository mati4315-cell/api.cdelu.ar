-- Schema generation 

SET FOREIGN_KEY_CHECKS=0;

-- Table: ads
CREATE TABLE IF NOT EXISTS `ads` (
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
  KEY `idx_activo` (`activo`),
  KEY `idx_categoria` (`categoria`),
  KEY `idx_prioridad` (`prioridad`),
  CONSTRAINT `ads_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table: com
CREATE TABLE IF NOT EXISTS `com` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) NOT NULL,
  `descripcion` text NOT NULL,
  `video_url` varchar(500) DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `com_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table: com_comments
CREATE TABLE IF NOT EXISTS `com_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `com_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `com_id` (`com_id`),
  CONSTRAINT `com_comments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `com_comments_ibfk_2` FOREIGN KEY (`com_id`) REFERENCES `com` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table: com_likes
CREATE TABLE IF NOT EXISTS `com_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `com_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_com` (`user_id`,`com_id`),
  KEY `com_id` (`com_id`),
  CONSTRAINT `com_likes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `com_likes_ibfk_2` FOREIGN KEY (`com_id`) REFERENCES `com` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table: comments
CREATE TABLE IF NOT EXISTS `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `news_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `news_id` (`news_id`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`news_id`) REFERENCES `news` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table: content_feed
CREATE TABLE IF NOT EXISTS `content_feed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) NOT NULL,
  `descripcion` text NOT NULL,
  `resumen` text DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `type` tinyint(4) NOT NULL,
  `original_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `original_url` varchar(500) DEFAULT NULL,
  `is_oficial` tinyint(1) DEFAULT NULL,
  `video_url` varchar(500) DEFAULT NULL,
  `likes_count` int(11) DEFAULT 0,
  `comments_count` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_type` (`type`),
  KEY `idx_published_at` (`published_at`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_likes` (`likes_count`),
  KEY `idx_comments` (`comments_count`),
  KEY `idx_type_published` (`type`,`published_at`),
  KEY `idx_original` (`type`,`original_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table: likes
CREATE TABLE IF NOT EXISTS `likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `news_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `news_id` (`news_id`),
  CONSTRAINT `likes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `likes_ibfk_2` FOREIGN KEY (`news_id`) REFERENCES `news` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table: lotteries
CREATE TABLE IF NOT EXISTS `lotteries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL COMMENT 'Título de la lotería',
  `description` text DEFAULT NULL COMMENT 'Descripción detallada',
  `image_url` varchar(500) DEFAULT NULL COMMENT 'URL de la imagen de la lotería',
  `is_free` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0: Pago, 1: Gratuita',
  `ticket_price` decimal(10,2) DEFAULT 0.00 COMMENT 'Precio por ticket (0 para gratuitas)',
  `min_tickets` int(11) NOT NULL DEFAULT 1 COMMENT 'Número mínimo de tickets para iniciar',
  `max_tickets` int(11) NOT NULL COMMENT 'Número máximo de tickets disponibles',
  `num_winners` int(11) NOT NULL DEFAULT 1 COMMENT 'Número de ganadores',
  `start_date` datetime NOT NULL COMMENT 'Fecha y hora de inicio',
  `end_date` datetime NOT NULL COMMENT 'Fecha y hora de finalización',
  `status` enum('draft','active','closed','finished','cancelled') NOT NULL DEFAULT 'draft' COMMENT 'Estado de la lotería',
  `created_by` int(11) NOT NULL COMMENT 'ID del administrador que creó la lotería',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `winner_selected_at` datetime DEFAULT NULL COMMENT 'Fecha cuando se seleccionaron los ganadores',
  `prize_description` text DEFAULT NULL COMMENT 'Descripción del premio',
  `terms_conditions` text DEFAULT NULL COMMENT 'Términos y condiciones',
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_dates` (`start_date`,`end_date`),
  KEY `idx_created_by` (`created_by`),
  KEY `idx_lotteries_status_dates` (`status`,`start_date`,`end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tabla principal de loterías';

-- Table: lottery_reserved_numbers
CREATE TABLE IF NOT EXISTS `lottery_reserved_numbers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lottery_id` int(11) NOT NULL COMMENT 'ID de la lotería',
  `ticket_number` int(11) NOT NULL COMMENT 'Número de ticket reservado',
  `user_id` int(11) NOT NULL COMMENT 'ID del usuario que reservó',
  `reserved_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha de reserva',
  `expires_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha de expiración de la reserva',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_lottery_number` (`lottery_id`,`ticket_number`),
  KEY `idx_lottery_id` (`lottery_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Números reservados temporalmente';

-- Table: lottery_settings
CREATE TABLE IF NOT EXISTS `lottery_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL COMMENT 'Clave de configuración',
  `setting_value` text DEFAULT NULL COMMENT 'Valor de configuración',
  `description` varchar(255) DEFAULT NULL COMMENT 'Descripción de la configuración',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_setting_key` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Configuración del sistema de lotería';

-- Table: lottery_tickets
CREATE TABLE IF NOT EXISTS `lottery_tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lottery_id` int(11) NOT NULL COMMENT 'ID de la lotería',
  `user_id` int(11) NOT NULL COMMENT 'ID del usuario',
  `ticket_number` int(11) NOT NULL COMMENT 'Número del ticket',
  `purchase_date` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Fecha de compra',
  `payment_status` enum('pending','paid','failed','refunded') NOT NULL DEFAULT 'pending' COMMENT 'Estado del pago',
  `payment_amount` decimal(10,2) DEFAULT 0.00 COMMENT 'Monto pagado',
  `payment_method` varchar(50) DEFAULT NULL COMMENT 'Método de pago',
  `transaction_id` varchar(255) DEFAULT NULL COMMENT 'ID de transacción externa',
  `is_winner` tinyint(1) DEFAULT 0 COMMENT '0: No ganador, 1: Ganador',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_lottery_ticket` (`lottery_id`,`ticket_number`),
  KEY `idx_lottery_id` (`lottery_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_payment_status` (`payment_status`),
  KEY `idx_is_winner` (`is_winner`),
  KEY `idx_lottery_tickets_lottery_user` (`lottery_id`,`user_id`),
  KEY `idx_lottery_tickets_status_winner` (`payment_status`,`is_winner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tickets de lotería';

-- Table: lottery_winners
CREATE TABLE IF NOT EXISTS `lottery_winners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lottery_id` int(11) NOT NULL COMMENT 'ID de la lotería',
  `ticket_id` int(11) NOT NULL COMMENT 'ID del ticket ganador',
  `user_id` int(11) NOT NULL COMMENT 'ID del usuario ganador',
  `ticket_number` int(11) NOT NULL COMMENT 'Número del ticket ganador',
  `prize_description` text DEFAULT NULL COMMENT 'Descripción del premio ganado',
  `notified_at` datetime DEFAULT NULL COMMENT 'Fecha de notificación al ganador',
  `claimed_at` datetime DEFAULT NULL COMMENT 'Fecha de reclamación del premio',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_lottery_winner` (`lottery_id`,`ticket_id`),
  KEY `idx_lottery_id` (`lottery_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_ticket_id` (`ticket_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Ganadores de loterías';

-- Table: news
CREATE TABLE IF NOT EXISTS `news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) NOT NULL,
  `descripcion` text NOT NULL,
  `resumen` text DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `original_url` varchar(500) DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `is_oficial` tinyint(1) DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `news_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table: roles
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table: survey_options
CREATE TABLE IF NOT EXISTS `survey_options` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) NOT NULL,
  `option_text` varchar(500) NOT NULL COMMENT 'Texto de la opción',
  `votes_count` int(11) DEFAULT 0 COMMENT 'Número de votos para esta opción',
  `display_order` int(11) DEFAULT 0 COMMENT 'Orden de visualización',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_survey_id` (`survey_id`),
  KEY `idx_display_order` (`display_order`),
  CONSTRAINT `survey_options_ibfk_1` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Opciones de respuesta para las encuestas';

-- Table: survey_stats
CREATE TABLE IF NOT EXISTS `survey_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) NOT NULL,
  `total_votes` int(11) DEFAULT 0,
  `unique_voters` int(11) DEFAULT 0,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_survey_stats` (`survey_id`),
  CONSTRAINT `survey_stats_ibfk_1` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Estadísticas cacheadas de encuestas';

-- Table: survey_votes
CREATE TABLE IF NOT EXISTS `survey_votes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) NOT NULL,
  `option_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL COMMENT 'ID del usuario (NULL para votos anónimos)',
  `user_ip` varchar(45) DEFAULT NULL COMMENT 'IP del usuario para evitar votos duplicados',
  `user_agent` text DEFAULT NULL COMMENT 'User agent para tracking',
  `voted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_vote` (`survey_id`,`user_id`,`option_id`),
  UNIQUE KEY `unique_ip_vote` (`survey_id`,`user_ip`,`option_id`),
  KEY `idx_survey_id` (`survey_id`),
  KEY `idx_option_id` (`option_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_voted_at` (`voted_at`),
  CONSTRAINT `survey_votes_ibfk_1` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE,
  CONSTRAINT `survey_votes_ibfk_2` FOREIGN KEY (`option_id`) REFERENCES `survey_options` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Registro de votos de usuarios';

-- Table: surveys
CREATE TABLE IF NOT EXISTS `surveys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL COMMENT 'Título de la encuesta',
  `description` text DEFAULT NULL COMMENT 'Descripción de la encuesta',
  `question` text NOT NULL COMMENT 'Pregunta principal',
  `status` enum('active','inactive','completed') DEFAULT 'active' COMMENT 'Estado de la encuesta',
  `is_multiple_choice` tinyint(1) DEFAULT 0 COMMENT 'Permite selección múltiple',
  `max_votes_per_user` int(11) DEFAULT 1 COMMENT 'Máximo de votos por usuario',
  `created_by` int(11) DEFAULT NULL COMMENT 'ID del administrador que creó la encuesta',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `expires_at` timestamp NULL DEFAULT NULL COMMENT 'Fecha de expiración de la encuesta',
  `total_votes` int(11) DEFAULT 0 COMMENT 'Total de votos recibidos',
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_expires_at` (`expires_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tabla principal de encuestas';

-- Table: users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `profile_picture_url` varchar(500) DEFAULT NULL COMMENT 'URL de la foto de perfil del usuario',
  `role_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Trigger: after_com_comments_insert
DELIMITER //
CREATE  TRIGGER after_com_comments_insert
AFTER INSERT ON com_comments FOR EACH ROW
BEGIN
  UPDATE content_feed 
  SET comments_count = comments_count + 1,
      updated_at = NOW()
  WHERE type = 2 AND original_id = NEW.com_id; END //
DELIMITER ;

-- Trigger: after_com_comments_delete
DELIMITER //
CREATE  TRIGGER after_com_comments_delete
AFTER DELETE ON com_comments FOR EACH ROW
BEGIN
  UPDATE content_feed 
  SET comments_count = GREATEST(0, comments_count - 1),
      updated_at = NOW()
  WHERE type = 2 AND original_id = OLD.com_id; END //
DELIMITER ;

-- Trigger: after_com_likes_insert
DELIMITER //
CREATE  TRIGGER after_com_likes_insert
AFTER INSERT ON com_likes FOR EACH ROW
BEGIN
  UPDATE content_feed 
  SET likes_count = likes_count + 1,
      updated_at = NOW()
  WHERE type = 2 AND original_id = NEW.com_id; END //
DELIMITER ;

-- Trigger: after_com_likes_delete
DELIMITER //
CREATE  TRIGGER after_com_likes_delete
AFTER DELETE ON com_likes FOR EACH ROW
BEGIN
  UPDATE content_feed 
  SET likes_count = GREATEST(0, likes_count - 1),
      updated_at = NOW()
  WHERE type = 2 AND original_id = OLD.com_id; END //
DELIMITER ;

-- Trigger: after_comments_insert
DELIMITER //
CREATE  TRIGGER after_comments_insert
AFTER INSERT ON comments FOR EACH ROW
BEGIN
  UPDATE content_feed 
  SET comments_count = comments_count + 1,
      updated_at = NOW()
  WHERE type = 1 AND original_id = NEW.news_id; END //
DELIMITER ;

-- Trigger: after_comments_delete
DELIMITER //
CREATE  TRIGGER after_comments_delete
AFTER DELETE ON comments FOR EACH ROW
BEGIN
  UPDATE content_feed 
  SET comments_count = GREATEST(0, comments_count - 1),
      updated_at = NOW()
  WHERE type = 1 AND original_id = OLD.news_id; END //
DELIMITER ;

-- Trigger: after_likes_insert
DELIMITER //
CREATE  TRIGGER after_likes_insert
AFTER INSERT ON likes FOR EACH ROW
BEGIN
  UPDATE content_feed 
  SET likes_count = likes_count + 1,
      updated_at = NOW()
  WHERE type = 1 AND original_id = NEW.news_id; END //
DELIMITER ;

-- Trigger: after_likes_delete
DELIMITER //
CREATE  TRIGGER after_likes_delete
AFTER DELETE ON likes FOR EACH ROW
BEGIN
  UPDATE content_feed 
  SET likes_count = GREATEST(0, likes_count - 1),
      updated_at = NOW()
  WHERE type = 1 AND original_id = OLD.news_id; END //
DELIMITER ;

SET FOREIGN_KEY_CHECKS=1;
