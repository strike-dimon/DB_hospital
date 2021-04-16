DROP DATABASE IF EXISTS hospital;

CREATE DATABASE hospital;

USE hospital;

DROP TABLE IF EXISTS `employees`;

CREATE TABLE `employees` (
	`id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`name` VARCHAR(145) NOT NULL,
	`surname` VARCHAR (145) NOT NULL,
	`id_position` SMALLINT UNSIGNED NOT NULL,
	`id_area` SMALLINT UNSIGNED NOT NULL,
	 INDEX fk_id_idx (`id`)
	 -- CONSTRAINT `fk_employees` FOREIGN KEY (`id`) REFERENCES `position` (`id_position`)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `profile_employees`;

CREATE TABLE `profile_employees` (
	`em_id` SMALLINT UNSIGNED NOT NULL,
	`birthday` DATE NOT NULL,
	`gender` ENUM ('f','m') NOT NULL,
	`family_status` BOOLEAN DEFAULT False,
	`education` VARCHAR(245) NOT NULL,
	`qualification` VARCHAR(245) NOT NULL,
	`email` VARCHAR(145) UNIQUE NOT NULL,
	`phone` INT UNSIGNED UNIQUE NOT NULL,
	`date_of_employment` DATE NOT NULL,
	`date_of_dismissal` DATE DEFAULT NULL,
	`password_hash` char(65) NOT NULL,
	UNIQUE INDEX email_unique (`email`),
	UNIQUE INDEX phone_unique (`phone`),
	CONSTRAINT fk_em_id FOREIGN KEY (`em_id`) REFERENCES `employees` (`id`)
 ) 	ENGINE=InnoDB;
 
DROP TABLE IF EXISTS `position`;

CREATE TABLE `position` (
	`id_position` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`role` VARCHAR(145) UNIQUE NOT NULL
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `area`;

CREATE TABLE `area` (
	`id_area` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`id_em` SMALLINT DEFAULT NULL,
	`id_patient` BIGINT UNSIGNED DEFAULT NULL
	-- CONSTRAINT fk_id_em FOREIGN KEY (`id_em`) REFERENCES `employees` (`id`)
) ENGINE=InnoDB;

ALTER TABLE `employees` ADD CONSTRAINT `fk_employees_pos` FOREIGN KEY (`id_position`) REFERENCES `position` (`id_position`);
ALTER TABLE `employees` ADD CONSTRAINT `fk_employees_area` FOREIGN KEY (`id_area`) REFERENCES `area` (`id_area`);

DROP TABLE IF EXISTS `patient`;

CREATE TABLE `patient` (
	`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`name` VARCHAR(145) NOT NULL,
	`surname` VARCHAR (145) NOT NULL,
	`area` SMALLINT UNSIGNED NOT NULL,
	`id_card` BIGINT UNSIGNED NOT NULL,
	 INDEX fk_id_idx (`id`),
	 INDEX fk_id_card_idx (`id_card`),
	 CONSTRAINT `fk_patient` FOREIGN KEY (`area`) REFERENCES `area` (`id_area`)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `profile_patient`;

CREATE TABLE `profile_patient` (
	`patient_id` BIGINT UNSIGNED NOT NULL,
	`birthday` DATE NOT NULL,
	`gender` ENUM ('f','m') NOT NULL,
	`adress` VARCHAR(245) UNIQUE NOT NULL,
	`email` VARCHAR(145) UNIQUE NOT NULL,
	`phone` INT UNSIGNED UNIQUE NOT NULL,
	`is_lung_snapshot` BOOLEAN DEFAULT NULL,
	`password_hash` char(65) NOT NULL,
	UNIQUE INDEX email_unique (`email`),
	UNIQUE INDEX phone_unique (`phone`),
	CONSTRAINT fk_id_patient FOREIGN KEY (`patient_id`) REFERENCES `patient` (`id`)
 ) 	ENGINE=InnoDB;

DROP TABLE IF EXISTS `patient_card`;

CREATE TABLE `patient_card` (
	`id_card` BIGINT UNSIGNED DEFAULT NULL,
	`id_area` SMALLINT UNSIGNED NOT NULL,
	`created_at` DATE NOT NULL,
	UNIQUE INDEX fk_id_card_idx (`id_card`),
	CONSTRAINT fk_id_card FOREIGN KEY (`id_card`) REFERENCES `patient` (`id`),
	CONSTRAINT fk_id_card_area FOREIGN KEY (`id_area`) REFERENCES `area` (`id_area`)
) ENGINE=InnoDB;


DROP TABLE IF EXISTS `fluorography`;

CREATE TABLE `fluorography` (
	`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`is_health` BOOLEAN NOT NULL,
	`created_at` DATE NOT NULL,
	`expired_at` DATE NOT NULL,
	UNIQUE INDEX fk_id__idx (`id`),
	CONSTRAINT fk_id_fluorography FOREIGN KEY (`id`) REFERENCES `profile_patient` (`patient_id`)
) ENGINE=InnoDB;



DROP TABLE IF EXISTS `admission_to_medicines`;

CREATE TABLE `admission_to_medicines` (
	`id` SMALLINT UNSIGNED NOT NULL,
	`level` ENUM ('1','2', '3') NOT NULL,
	`id_position` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	CONSTRAINT fk_id_admission FOREIGN KEY (`id`) REFERENCES `employees` (`id`),
	CONSTRAINT fk_id_admission_position FOREIGN KEY (`id_position`) REFERENCES `position` (`id_position`)
) ENGINE=InnoDB;	


DROP TABLE IF EXISTS `medicines_storage`;

CREATE TABLE `medicines_storage` (
	`id` BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	`name` VARCHAR(245) UNIQUE NOT NULL,
	`level` ENUM ('1','2', '3') NOT NULL,
	`balance` INT,
	`update_date` DATETIME NOT NULL,
	INDEX fk_drugs (`id`)
) ENGINE=InnoDB;	


DROP TABLE IF EXISTS `medicines_logs`;

CREATE TABLE `medicines_logs` (
	`id` BIGINT UNSIGNED NOT NULL,
	`drugs_id` BIGINT UNSIGNED NOT NULL,
	`quantity` SMALLINT UNSIGNED NOT NULL,
	`id_doctor`SMALLINT UNSIGNED NOT NULL,
	`id_patient` BIGINT UNSIGNED NOT NULL,
	`date` DATETIME NOT NULL,
	INDEX fk_id_logs_drugs (`id`),
	CONSTRAINT fk_id_doctor FOREIGN KEY (`id_doctor`) REFERENCES `employees` (`id`),
	CONSTRAINT fk_id_p FOREIGN KEY (`id_patient`) REFERENCES `patient` (`id`)
) ENGINE=InnoDB;	

ALTER TABLE `medicines_storage` ADD CONSTRAINT `fk_drugs` FOREIGN KEY (`id`) REFERENCES `medicines_logs` (`id`);
	