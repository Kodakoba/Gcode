/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE TABLE IF NOT EXISTS `bw_baseareas` (
  `zone_id` int NOT NULL AUTO_INCREMENT,
  `zone_name` varchar(121) DEFAULT NULL,
  `base_id` int NOT NULL,
  `zone_max_x` float NOT NULL,
  `zone_max_y` float NOT NULL,
  `zone_max_z` float NOT NULL,
  `zone_min_x` float NOT NULL,
  `zone_min_y` float NOT NULL,
  `zone_min_z` float NOT NULL,
  PRIMARY KEY (`zone_id`)
) ENGINE=InnoDB AUTO_INCREMENT=243 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `bw_bases` (
  `base_id` int NOT NULL AUTO_INCREMENT,
  `base_name` varchar(500) NOT NULL,
  `base_data` json DEFAULT NULL,
  `map_name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`base_id`)
) ENGINE=InnoDB AUTO_INCREMENT=277 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `bw_plydata` (
  `puid` bigint unsigned NOT NULL,
  `money` bigint unsigned NOT NULL DEFAULT '300',
  `lvl` int unsigned NOT NULL DEFAULT '1',
  `xp` bigint unsigned NOT NULL DEFAULT '0',
  `playtime` bigint NOT NULL DEFAULT '0',
  `prestige` bigint unsigned NOT NULL DEFAULT '0',
  `ptokens` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`puid`),
  UNIQUE KEY `puid_UNIQUE` (`puid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `bw_rollback` (
  `puid` bigint unsigned NOT NULL,
  `money` bigint unsigned DEFAULT NULL,
  `ents` json DEFAULT NULL,
  PRIMARY KEY (`puid`),
  UNIQUE KEY `puid_UNIQUE` (`puid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `cum_ranks` (
  `permissions` text,
  `rankid` int NOT NULL,
  PRIMARY KEY (`rankid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELIMITER //
CREATE FUNCTION `GetBaseItemID`(
	comp_name VARCHAR(254)
) RETURNS int
    MODIFIES SQL DATA
    DETERMINISTIC
BEGIN
-- <Body>
	DECLARE ret INT DEFAULT NULL;
    SELECT id INTO ret FROM itemids WHERE name = comp_name;

    IF ( isnull(ret) ) THEN
		INSERT INTO `itemids`(name) VALUES(comp_name);
		RETURN LAST_INSERT_ID();
	END IF;

	RETURN ret;
-- </Body>
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `InsertByIDInInventory`(
	id INT UNSIGNED, 
inv TEXT, 
puid BIGINT, 
jsDat TEXT
)
BEGIN
-- <Body>
DECLARE uid INT UNSIGNED;
	INSERT INTO items(iid, `data`) VALUES(id, jsDat);
    SET uid = last_insert_id();

	SET @t1 = CONCAT('INSERT INTO ', inv ,'(uid, puid) VALUES(', uid, ", ", puid, ')' ); # oh my fucking god actually kill me
	PREPARE stmt3 FROM @t1;
	EXECUTE stmt3;
	DEALLOCATE PREPARE stmt3;

	SELECT uid;
-- </Body>
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `InsertByItemNameInInventory`(
	itemname VARCHAR(254), 
inv TEXT, 
puid BIGINT, 
jsDat TEXT
)
BEGIN
-- <Body>
	DECLARE uid INT UNSIGNED;
    DECLARE iid INT UNSIGNED;
    SELECT id INTO iid FROM itemids WHERE name = itemname;
	INSERT INTO items(iid, `data`) VALUES(iid, jsDat);
    SET uid = last_insert_id();

	SET @t1 = CONCAT('INSERT INTO ', inv ,'(uid, puid)
		VALUES(', uid, ", ", puid,')' ); # oh my fucking god actually kill me
	PREPARE stmt3 FROM @t1;
	EXECUTE stmt3;
	DEALLOCATE PREPARE stmt3;

	SELECT uid;

-- </Body>
END//
DELIMITER ;

CREATE TABLE IF NOT EXISTS `inv_entity` (
  `uid` int NOT NULL,
  `puid` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `uid` (`uid`),
  CONSTRAINT `inv_entity_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `items_old` (`uid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `inv_ply_char` (
  `uid` int NOT NULL,
  `puid` bigint unsigned DEFAULT NULL,
  `slotid` mediumint unsigned DEFAULT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `uid` (`uid`),
  UNIQUE KEY `uq_slot_puid` (`puid`,`slotid`),
  CONSTRAINT `inv_ply_char_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `items_old` (`uid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `inv_ply_perma` (
  `uid` int NOT NULL,
  `puid` bigint unsigned DEFAULT NULL,
  `slotid` mediumint unsigned DEFAULT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `uid` (`uid`),
  UNIQUE KEY `uq_slot_puid` (`puid`,`slotid`),
  CONSTRAINT `inv_ply_perma_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `items_old` (`uid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `inv_ply_temp` (
  `uid` int NOT NULL,
  `puid` bigint unsigned DEFAULT NULL,
  `slotid` mediumint unsigned DEFAULT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `uid` (`uid`),
  UNIQUE KEY `uq_slot_puid` (`puid`,`slotid`),
  CONSTRAINT `inv_ply_temp_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `items_old` (`uid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `inv_ply_vault` (
  `uid` int NOT NULL,
  `puid` bigint unsigned DEFAULT NULL,
  `slotid` mediumint unsigned DEFAULT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `uid` (`uid`),
  UNIQUE KEY `uq_slot_puid` (`puid`,`slotid`),
  CONSTRAINT `inv_ply_vault_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `items_old` (`uid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `itemids` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(254) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=123 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `items` (
  `uid` int NOT NULL AUTO_INCREMENT,
  `iid` int NOT NULL,
  `owner` bigint DEFAULT NULL,
  `inventory` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `slot` int DEFAULT NULL,
  `data` json DEFAULT NULL,
  PRIMARY KEY (`uid`) USING BTREE,
  UNIQUE KEY `uid_UNIQUE` (`uid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=34727 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `nx_bans` (
  `puid` bigint NOT NULL,
  `banTime` bigint NOT NULL,
  `unbanTime` bigint NOT NULL,
  `admin` mediumtext,
  `reason` mediumtext,
  `lastname` tinytext,
  PRIMARY KEY (`puid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `nx_detections` (
  `dataid` int NOT NULL AUTO_INCREMENT,
  `uid` bigint unsigned NOT NULL,
  `detection` smallint NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `extra_data` mediumtext,
  PRIMARY KEY (`dataid`)
) ENGINE=InnoDB AUTO_INCREMENT=1642 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `research` (
  `puid` bigint NOT NULL,
  `perks` json DEFAULT NULL,
  PRIMARY KEY (`puid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `todo` (
  `uid` int NOT NULL AUTO_INCREMENT,
  `str` text,
  `done` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELIMITER //
CREATE PROCEDURE `todoDeleteAndReturn`(id INT)
BEGIN
	SELECT * FROM todo WHERE uid = id;
    DELETE FROM todo WHERE uid = id;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `todoSolveAndReturn`(id INT)
BEGIN
	UPDATE todo SET done = TRUE WHERE uid = id;
	SELECT * FROM todo WHERE uid = id;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
