-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 02-04-2026 a las 04:00:54
-- Versión del servidor: 8.0.45
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `cdelu2`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `admin_settings`
--

CREATE TABLE `admin_settings` (
  `key` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `value` text COLLATE utf8mb4_general_ci NOT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `admin_settings`
--

INSERT INTO `admin_settings` (`key`, `value`, `updated_at`) VALUES
('auto_backup_enabled', 'true', '2026-04-02 01:59:11'),
('video_settings', '{\"isVideoEnabled\":false}', '2026-04-02 01:59:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ads`
--

CREATE TABLE `ads` (
  `id` int NOT NULL,
  `titulo` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_general_ci,
  `image_url` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `enlace_destino` varchar(500) COLLATE utf8mb4_general_ci NOT NULL,
  `texto_opcional` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `categoria` varchar(100) COLLATE utf8mb4_general_ci DEFAULT 'general',
  `prioridad` int DEFAULT '1',
  `activo` tinyint(1) DEFAULT '1',
  `impresiones_maximas` int DEFAULT '0',
  `impresiones_actuales` int DEFAULT '0',
  `clics_count` int DEFAULT '0',
  `created_by` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `com`
--

CREATE TABLE `com` (
  `id` int NOT NULL,
  `titulo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `video_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `com`
--
DELIMITER $$
CREATE TRIGGER `after_com_delete` AFTER DELETE ON `com` FOR EACH ROW BEGIN
    DELETE FROM content_feed WHERE content_type = 'community' AND reference_id = OLD.id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_com_insert` AFTER INSERT ON `com` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comments`
--

CREATE TABLE `comments` (
  `id` int NOT NULL,
  `news_id` int NOT NULL,
  `user_id` int NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `com_comments`
--

CREATE TABLE `com_comments` (
  `id` int NOT NULL,
  `com_id` int NOT NULL,
  `user_id` int NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `com_likes`
--

CREATE TABLE `com_likes` (
  `id` int NOT NULL,
  `com_id` int NOT NULL,
  `user_id` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `content_comments`
--

CREATE TABLE `content_comments` (
  `id` int NOT NULL,
  `feed_id` int NOT NULL,
  `user_id` int NOT NULL,
  `content` text COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `content_feed`
--

CREATE TABLE `content_feed` (
  `id` int NOT NULL,
  `content_type` enum('news','community') COLLATE utf8mb4_general_ci NOT NULL,
  `reference_id` int NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `image_url` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `video_url` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `user_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `user_profile_picture` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `content_likes`
--

CREATE TABLE `content_likes` (
  `id` int NOT NULL,
  `content_id` int NOT NULL COMMENT 'ID del contenido en content_feed',
  `user_id` int NOT NULL COMMENT 'ID del usuario que dio like',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `content_likes`
--

INSERT INTO `content_likes` (`id`, `content_id`, `user_id`, `created_at`, `updated_at`) VALUES
(1, 1, 5, '2025-05-31 00:15:07', '2026-03-20 11:38:53'),
(2, 2, 1, '2025-05-28 15:19:54', '2026-03-20 11:38:53'),
(3, 2, 5, '2025-05-31 00:15:05', '2026-03-20 11:38:53'),
(4, 6, 5, '2025-05-31 00:15:12', '2026-03-20 11:38:53'),
(5, 8, 5, '2025-05-31 00:15:17', '2026-03-20 11:38:53'),
(6, 12, 1, '2025-05-28 21:22:32', '2026-03-20 11:38:53'),
(7, 13, 1, '2025-05-28 21:22:39', '2026-03-20 11:38:53'),
(8, 21, 5, '2025-05-31 03:13:22', '2026-03-20 11:38:53'),
(9, 27, 5, '2025-05-31 00:15:21', '2026-03-20 11:38:53'),
(10, 37, 5, '2025-05-30 23:54:23', '2026-03-20 11:38:53'),
(11, 39, 5, '2025-05-31 00:15:28', '2026-03-20 11:38:53'),
(12, 44, 5, '2025-05-31 00:15:44', '2026-03-20 11:38:53'),
(13, 46, 5, '2025-05-31 00:15:40', '2026-03-20 11:38:53'),
(14, 48, 5, '2025-05-30 18:41:04', '2026-03-20 11:38:53'),
(15, 53, 5, '2025-05-30 18:38:20', '2026-03-20 11:38:53'),
(16, 54, 5, '2025-05-30 18:38:12', '2026-03-20 11:38:53'),
(17, 55, 5, '2025-05-31 03:24:36', '2026-03-20 11:38:53'),
(18, 56, 5, '2025-05-30 18:37:35', '2026-03-20 11:38:53'),
(19, 58, 5, '2025-05-30 18:39:26', '2026-03-20 11:38:53'),
(20, 63, 5, '2025-05-30 18:37:26', '2026-03-20 11:38:53'),
(21, 64, 5, '2025-05-31 03:12:28', '2026-03-20 11:38:53'),
(22, 71, 5, '2025-05-30 23:56:18', '2026-03-20 11:38:53'),
(23, 73, 5, '2025-05-31 06:20:03', '2026-03-20 11:38:53'),
(24, 74, 5, '2025-05-31 00:00:07', '2026-03-20 11:38:53'),
(25, 76, 5, '2025-05-31 03:21:25', '2026-03-20 11:38:53'),
(26, 77, 5, '2025-06-01 03:01:34', '2026-03-20 11:38:53'),
(27, 79, 5, '2025-06-01 10:39:36', '2026-03-20 11:38:53'),
(28, 81, 5, '2025-06-01 03:01:18', '2026-03-20 11:38:53'),
(29, 95, 5, '2025-06-01 22:19:36', '2026-03-20 11:38:53'),
(30, 96, 5, '2025-06-01 22:19:33', '2026-03-20 11:38:53'),
(31, 97, 5, '2025-06-01 22:19:32', '2026-03-20 11:38:53'),
(32, 98, 5, '2025-06-01 22:19:29', '2026-03-20 11:38:53'),
(33, 99, 5, '2025-06-01 22:19:28', '2026-03-20 11:38:53'),
(34, 851, 1, '2025-07-09 09:23:05', '2026-03-20 11:38:53'),
(35, 879, 1, '2025-07-09 09:23:31', '2026-03-20 11:38:53'),
(36, 1180, 6, '2025-07-24 11:16:37', '2026-03-20 11:38:53'),
(37, 1180, 1, '2025-07-27 01:50:52', '2026-03-20 11:38:53'),
(38, 1189, 1, '2025-07-27 10:59:38', '2026-03-20 11:38:53'),
(64, 66, 5, '2025-05-30 23:50:59', '2026-03-20 11:38:53'),
(65, 75, 5, '2025-05-31 06:19:57', '2026-03-20 11:38:53'),
(66, 91, 5, '2025-06-01 17:00:56', '2026-03-20 11:38:53'),
(67, 100, 5, '2025-06-01 22:19:24', '2026-03-20 11:38:53');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `likes`
--

CREATE TABLE `likes` (
  `id` int NOT NULL,
  `news_id` int NOT NULL,
  `user_id` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lotteries`
--

CREATE TABLE `lotteries` (
  `id` int NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `max_tickets` int NOT NULL,
  `ticket_price` decimal(10,2) DEFAULT '0.00',
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `status` enum('pending','active','closed','cancelled') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lottery_reserved_numbers`
--

CREATE TABLE `lottery_reserved_numbers` (
  `id` int NOT NULL,
  `lottery_id` int NOT NULL COMMENT 'ID de la lotería',
  `ticket_number` int NOT NULL COMMENT 'Número de ticket reservado',
  `user_id` int NOT NULL COMMENT 'ID del usuario que reservó',
  `reserved_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha de reserva',
  `expires_at` datetime DEFAULT NULL COMMENT 'Fecha de expiración de la reserva'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Números reservados temporalmente';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lottery_settings`
--

CREATE TABLE `lottery_settings` (
  `id` int NOT NULL,
  `setting_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Clave de configuración',
  `setting_value` text COLLATE utf8mb4_unicode_ci COMMENT 'Valor de configuración',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Descripción de la configuración',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Configuración del sistema de lotería';

--
-- Volcado de datos para la tabla `lottery_settings`
--

INSERT INTO `lottery_settings` (`id`, `setting_key`, `setting_value`, `description`, `created_at`, `updated_at`) VALUES
(1, 'reservation_timeout', '300', 'Tiempo de reserva de números en segundos (5 minutos)', '2026-03-20 22:51:41', '2026-03-20 22:51:41'),
(2, 'max_tickets_per_user', '10', 'Máximo número de tickets por usuario por lotería', '2026-03-20 22:51:41', '2026-03-20 22:51:41'),
(3, 'auto_close_enabled', '1', 'Habilitar cierre automático de loterías', '2026-03-20 22:51:41', '2026-03-20 22:51:41'),
(4, 'notification_email', 'admin@cdelu.ar', 'Email para notificaciones de lotería', '2026-03-20 22:51:41', '2026-03-20 22:51:41'),
(5, 'default_currency', 'ARS', 'Moneda por defecto para loterías de pago', '2026-03-20 22:51:41', '2026-03-20 22:51:41');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lottery_tickets`
--

CREATE TABLE `lottery_tickets` (
  `id` int NOT NULL,
  `lottery_id` int NOT NULL,
  `user_id` int NOT NULL,
  `ticket_number` int NOT NULL,
  `purchase_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `payment_status` enum('pending','paid','failed','refunded') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `payment_amount` decimal(10,2) DEFAULT '0.00',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lottery_winners`
--

CREATE TABLE `lottery_winners` (
  `id` int NOT NULL,
  `lottery_id` int NOT NULL,
  `ticket_id` int NOT NULL,
  `user_id` int NOT NULL,
  `ticket_number` int NOT NULL,
  `prize_description` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `news`
--

CREATE TABLE `news` (
  `id` int NOT NULL,
  `titulo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_thumbnail_url` text COLLATE utf8mb4_unicode_ci,
  `diario` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `categoria` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `original_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `is_oficial` tinyint(1) DEFAULT '1',
  `created_by` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `news`
--
DELIMITER $$
CREATE TRIGGER `after_news_insert` AFTER INSERT ON `news` FOR EACH ROW BEGIN
    INSERT INTO content_feed (
        content_type, reference_id, title, description, 
        image_url, user_id, user_name, created_at
    ) VALUES (
        'news', NEW.id, NEW.titulo, NEW.descripcion, 
        NEW.image_url, NEW.created_by, 'Admin Oficial', NEW.created_at
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` int NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `name`) VALUES
(1, 'administrador'),
(2, 'colaborador'),
(3, 'usuario');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `surveys`
--

CREATE TABLE `surveys` (
  `id` int NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `question` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('active','inactive','completed') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `surveys`
--
DELIMITER $$
CREATE TRIGGER `create_survey_stats` AFTER INSERT ON `surveys` FOR EACH ROW BEGIN
    INSERT INTO survey_stats (survey_id, total_votes, unique_voters)
    VALUES (NEW.id, 0, 0);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `survey_options`
--

CREATE TABLE `survey_options` (
  `id` int NOT NULL,
  `survey_id` int NOT NULL,
  `option_text` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `votes_count` int DEFAULT '0',
  `display_order` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `survey_stats`
--

CREATE TABLE `survey_stats` (
  `id` int NOT NULL,
  `survey_id` int NOT NULL,
  `total_votes` int DEFAULT '0',
  `unique_voters` int DEFAULT '0',
  `last_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `survey_votes`
--

CREATE TABLE `survey_votes` (
  `id` int NOT NULL,
  `survey_id` int NOT NULL,
  `option_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `user_ip` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `voted_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `system_modules`
--

CREATE TABLE `system_modules` (
  `id` int NOT NULL,
  `module_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `display_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '1',
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `system_modules`
--

INSERT INTO `system_modules` (`id`, `module_name`, `display_name`, `description`, `enabled`, `updated_at`) VALUES
(1, 'ads', 'Publicidad', 'Gestión de banners publicitarios', 1, '2026-04-02 01:59:11'),
(2, 'lotteries', 'Sorteos', 'Sistema de loterías y tickets', 1, '2026-04-02 01:59:11'),
(3, 'surveys', 'Encuestas', 'Sistema de votación y encuestas', 1, '2026-04-02 01:59:11'),
(4, 'community', 'Comunidad', 'Feed de publicaciones de usuarios', 1, '2026-04-02 01:59:11'),
(5, 'news', 'Noticias', 'Portal de noticias oficiales', 1, '2026-04-02 01:59:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_general_ci NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `bio` text COLLATE utf8mb4_general_ci,
  `location` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `website` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT '0',
  `profile_picture_url` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `role_id` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `nombre`, `email`, `username`, `bio`, `location`, `website`, `is_verified`, `profile_picture_url`, `password`, `role_id`, `created_at`, `updated_at`) VALUES
(1, 'Matias Administrador', 'matias4315@gmail.com', 'admin', NULL, NULL, NULL, 0, NULL, '$2a$10$STw3rGCqDQUjQrE8NpYSdOETELiFRHDFiQgZFWnma37x.hnPdrfWC', 1, '2026-04-02 01:59:11', '2026-04-02 01:59:11');

--
-- Disparadores `users`
--
DELIMITER $$
CREATE TRIGGER `after_user_update` AFTER UPDATE ON `users` FOR EACH ROW BEGIN
  IF OLD.nombre != NEW.nombre OR OLD.profile_picture_url != NEW.profile_picture_url THEN
    UPDATE content_feed 
    SET user_name = NEW.nombre, user_profile_picture = NEW.profile_picture_url
    WHERE user_id = NEW.id;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_follows`
--

CREATE TABLE `user_follows` (
  `id` int NOT NULL,
  `follower_id` int NOT NULL,
  `following_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `admin_settings`
--
ALTER TABLE `admin_settings`
  ADD PRIMARY KEY (`key`);

--
-- Indices de la tabla `ads`
--
ALTER TABLE `ads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indices de la tabla `com`
--
ALTER TABLE `com`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `news_id` (`news_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `com_comments`
--
ALTER TABLE `com_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `com_id` (`com_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `com_likes`
--
ALTER TABLE `com_likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_like` (`com_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `content_comments`
--
ALTER TABLE `content_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_feed_id` (`feed_id`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- Indices de la tabla `content_feed`
--
ALTER TABLE `content_feed`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_content_type` (`content_type`),
  ADD KEY `idx_reference_id` (`reference_id`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indices de la tabla `content_likes`
--
ALTER TABLE `content_likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_content` (`user_id`,`content_id`),
  ADD KEY `idx_content_id` (`content_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_content_user` (`content_id`,`user_id`);

--
-- Indices de la tabla `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_news_like` (`news_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `lotteries`
--
ALTER TABLE `lotteries`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `lottery_reserved_numbers`
--
ALTER TABLE `lottery_reserved_numbers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_lottery_number` (`lottery_id`,`ticket_number`),
  ADD KEY `idx_lottery_id` (`lottery_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_expires_at` (`expires_at`);

--
-- Indices de la tabla `lottery_settings`
--
ALTER TABLE `lottery_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_setting_key` (`setting_key`);

--
-- Indices de la tabla `lottery_tickets`
--
ALTER TABLE `lottery_tickets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_lottery_ticket` (`lottery_id`,`ticket_number`),
  ADD KEY `idx_lottery_id` (`lottery_id`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- Indices de la tabla `lottery_winners`
--
ALTER TABLE `lottery_winners`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_lottery_winner` (`lottery_id`,`ticket_id`),
  ADD KEY `idx_lottery_id` (`lottery_id`);

--
-- Indices de la tabla `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indices de la tabla `surveys`
--
ALTER TABLE `surveys`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `survey_options`
--
ALTER TABLE `survey_options`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_survey_id` (`survey_id`);

--
-- Indices de la tabla `survey_stats`
--
ALTER TABLE `survey_stats`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_survey_stats` (`survey_id`);

--
-- Indices de la tabla `survey_votes`
--
ALTER TABLE `survey_votes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_survey_id` (`survey_id`),
  ADD KEY `idx_option_id` (`option_id`);

--
-- Indices de la tabla `system_modules`
--
ALTER TABLE `system_modules`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `module_name` (`module_name`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `role_id` (`role_id`);

--
-- Indices de la tabla `user_follows`
--
ALTER TABLE `user_follows`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_follow` (`follower_id`,`following_id`),
  ADD KEY `idx_follower` (`follower_id`),
  ADD KEY `idx_following` (`following_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `ads`
--
ALTER TABLE `ads`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `com`
--
ALTER TABLE `com`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `com_comments`
--
ALTER TABLE `com_comments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `com_likes`
--
ALTER TABLE `com_likes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `content_comments`
--
ALTER TABLE `content_comments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `content_feed`
--
ALTER TABLE `content_feed`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `content_likes`
--
ALTER TABLE `content_likes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT de la tabla `likes`
--
ALTER TABLE `likes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `lotteries`
--
ALTER TABLE `lotteries`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `lottery_reserved_numbers`
--
ALTER TABLE `lottery_reserved_numbers`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `lottery_settings`
--
ALTER TABLE `lottery_settings`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `lottery_tickets`
--
ALTER TABLE `lottery_tickets`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `lottery_winners`
--
ALTER TABLE `lottery_winners`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `news`
--
ALTER TABLE `news`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `surveys`
--
ALTER TABLE `surveys`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `survey_options`
--
ALTER TABLE `survey_options`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `survey_stats`
--
ALTER TABLE `survey_stats`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `survey_votes`
--
ALTER TABLE `survey_votes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `system_modules`
--
ALTER TABLE `system_modules`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `user_follows`
--
ALTER TABLE `user_follows`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `ads`
--
ALTER TABLE `ads`
  ADD CONSTRAINT `ads_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `content_comments`
--
ALTER TABLE `content_comments`
  ADD CONSTRAINT `content_comments_ibfk_1` FOREIGN KEY (`feed_id`) REFERENCES `content_feed` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `news`
--
ALTER TABLE `news`
  ADD CONSTRAINT `news_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `survey_options`
--
ALTER TABLE `survey_options`
  ADD CONSTRAINT `survey_options_ibfk_1` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `survey_stats`
--
ALTER TABLE `survey_stats`
  ADD CONSTRAINT `survey_stats_ibfk_1` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `survey_votes`
--
ALTER TABLE `survey_votes`
  ADD CONSTRAINT `survey_votes_ibfk_1` FOREIGN KEY (`survey_id`) REFERENCES `surveys` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `survey_votes_ibfk_2` FOREIGN KEY (`option_id`) REFERENCES `survey_options` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);

--
-- Filtros para la tabla `user_follows`
--
ALTER TABLE `user_follows`
  ADD CONSTRAINT `user_follows_ibfk_1` FOREIGN KEY (`follower_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_follows_ibfk_2` FOREIGN KEY (`following_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
