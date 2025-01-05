-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : sam. 04 jan. 2025 à 16:42
-- Version du serveur : 9.1.0
-- Version de PHP : 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `cabinet`
--

-- --------------------------------------------------------

--
-- Structure de la table `commander`
--

DROP TABLE IF EXISTS `commander`;
CREATE TABLE IF NOT EXISTS `commander` (
  `nmr_commande` int NOT NULL AUTO_INCREMENT,
  `medecin_id` int NOT NULL,
  `prothesiste_id` int NOT NULL,
  `date_commande` date NOT NULL,
  `etat_commande` enum('En attente','En cours','Livrée','Annulée') DEFAULT 'En attente',
  PRIMARY KEY (`nmr_commande`,`medecin_id`,`prothesiste_id`),
  KEY `medecin_id` (`medecin_id`),
  KEY `prothesiste_id` (`prothesiste_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `consultation`
--

DROP TABLE IF EXISTS `consultation`;
CREATE TABLE IF NOT EXISTS `consultation` (
  `medecin_id` int NOT NULL,
  `patient_id` int NOT NULL,
  `date_consultation` datetime NOT NULL,
  PRIMARY KEY (`medecin_id`,`patient_id`,`date_consultation`),
  KEY `patient_id` (`patient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `deal`
--

DROP TABLE IF EXISTS `deal`;
CREATE TABLE IF NOT EXISTS `deal` (
  `secretaire_id` int NOT NULL,
  `fournisseur_id` int NOT NULL,
  `date_deal` datetime NOT NULL,
  `details_deal` text,
  PRIMARY KEY (`secretaire_id`,`fournisseur_id`,`date_deal`),
  KEY `fournisseur_id` (`fournisseur_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `fournisseur`
--

DROP TABLE IF EXISTS `fournisseur`;
CREATE TABLE IF NOT EXISTS `fournisseur` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `contact` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `fournisseur`
--

INSERT INTO `fournisseur` (`id`, `nom`, `prenom`, `contact`) VALUES
(1, 'dabouz ', 'mohamed ', '0795855622'),
(2, 'zaki', 'zaki', '12345678910'),
(3, 'Dupont', 'Jean', 'jean.dupont@mail.com'),
(4, 'Lemoine', 'Sophie', 'sophie.lemoine@fournisseur.com'),
(5, 'Martin', 'Pierre', 'pierre.martin@supplies.fr'),
(6, 'Durand', 'Claire', 'claire.durand@provider.com'),
(7, 'Dupont', 'Jean', 'jean.dupont@mail.com'),
(9, 'Martin', 'Pierre', 'pierre.martin@supplies.fr');

-- --------------------------------------------------------

--
-- Structure de la table `historique_medical`
--

DROP TABLE IF EXISTS `historique_medical`;
CREATE TABLE IF NOT EXISTS `historique_medical` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int DEFAULT NULL,
  `date_consultation` date NOT NULL,
  `diagnostic` text,
  `traitement` text,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `patient_id` (`patient_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `historique_medical`
--

INSERT INTO `historique_medical` (`id`, `patient_id`, `date_consultation`, `diagnostic`, `traitement`, `notes`) VALUES
(1, 1, '2024-10-15', 'Douleurs dentaires', 'Examen et extraction dentaire', 'Patient souffre de douleurs aiguës à la mâchoire droite'),
(2, 2, '2024-11-22', 'Fracture du bras', 'Plâtre et suivi', 'Fracture de l\'ulna gauche après une chute'),
(3, 3, '2024-12-01', 'Rhinite allergique', 'Prescription d\'antihistaminique', 'Symptômes de nez bouché et d\'éternuements fréquents'),
(4, 4, '2024-12-05', 'Problèmes de digestion', 'Tests gastro-intestinaux', 'Troubles digestifs après les repas');

-- --------------------------------------------------------

--
-- Structure de la table `liver`
--

DROP TABLE IF EXISTS `liver`;
CREATE TABLE IF NOT EXISTS `liver` (
  `livreur_id` int NOT NULL,
  `prothesiste_id` int NOT NULL,
  `date_livraison` datetime DEFAULT NULL,
  `numero_commande` varchar(50) NOT NULL,
  `etat_livraison` enum('En attente','En cours','Livré') DEFAULT 'En attente',
  PRIMARY KEY (`livreur_id`,`prothesiste_id`,`numero_commande`),
  KEY `prothesiste_idd` (`prothesiste_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `livreur`
--

DROP TABLE IF EXISTS `livreur`;
CREATE TABLE IF NOT EXISTS `livreur` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `contact` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `livreur`
--

INSERT INTO `livreur` (`id`, `nom`, `prenom`, `contact`) VALUES
(1, 'Dufresne', 'Louis', 'louis.dufresne@medecin.com'),
(2, 'Lemoine', 'Isabelle', 'isabelle.lemoine@clinic.net'),
(3, 'Tanguy', 'Robert', 'robert.tanguy@doctors.org');

-- --------------------------------------------------------

--
-- Structure de la table `medecin`
--

DROP TABLE IF EXISTS `medecin`;
CREATE TABLE IF NOT EXISTS `medecin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `specialite` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `medecin`
--

INSERT INTO `medecin` (`id`, `nom`, `prenom`, `specialite`, `email`, `password`) VALUES
(1, 'Leclerc', 'Marc', '', 'marc.leclerc@medecin.fr', 'Med1234#'),
(2, 'Benoit', 'Claire', '', 'claire.benoit@hospital.com', 'Clair@567'),
(3, 'Charpentier', 'Luc', '', 'luc.charpentier@doctor.org', 'Luc98765'),
(4, 'Fournier', 'Elise', '', 'elise.fournier@clinic.com', 'Elise2024$'),
(5, 'Dufresne', 'Louis', '', 'louis.dufresne@medecin.com', ''),
(6, 'Dubois', 'Alice', '', 'alice.dubois@hospital.com', ''),
(7, 'Tanguy', 'Robert', '', 'robert.tanguy@doctors.org', ''),
(8, 'Lemoine', 'Isabelle', '', 'isabelle.lemoine@clinic.net', '');

-- --------------------------------------------------------

--
-- Structure de la table `patient`
--

DROP TABLE IF EXISTS `patient`;
CREATE TABLE IF NOT EXISTS `patient` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `date_naissance` date NOT NULL,
  `telephone` varchar(20) DEFAULT NULL,
  `rendez` int DEFAULT NULL,
  `historique` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `rendez` (`rendez`),
  KEY `historique` (`historique`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `patient`
--

INSERT INTO `patient` (`id`, `nom`, `prenom`, `email`, `date_naissance`, `telephone`, `rendez`, `historique`) VALUES
(1, 'Dupont', 'Marie', 'marie.dupont@example.com', '1985-04-15', '0123456789', NULL, NULL),
(2, 'Lefevre', 'Jean', 'jean.lefevre@example.com', '1990-07-22', '0987654321', NULL, NULL),
(3, 'Martin', 'Claire', 'claire.martin@example.com', '1978-11-10', '0145896321', NULL, NULL),
(4, 'Durand', 'Pierre', 'pierre.durand@example.com', '2000-02-25', '0162231456', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `prothese`
--

DROP TABLE IF EXISTS `prothese`;
CREATE TABLE IF NOT EXISTS `prothese` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `materiau` varchar(255) DEFAULT NULL,
  `prix` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `prothese`
--

INSERT INTO `prothese` (`id`, `type`, `materiau`, `prix`) VALUES
(1, 'Prothèse dentaire', 'Céramique', 1500.00),
(2, 'Prothèse mammaire', 'Silicone', 1200.00),
(3, 'Prothèse auditive', 'Plastique', 500.00);

-- --------------------------------------------------------

--
-- Structure de la table `prothesiste`
--

DROP TABLE IF EXISTS `prothesiste`;
CREATE TABLE IF NOT EXISTS `prothesiste` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `prothese_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `prothese_id` (`prothese_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `prothesiste`
--

INSERT INTO `prothesiste` (`id`, `nom`, `prenom`, `email`, `password`, `prothese_id`) VALUES
(1, 'Dupont', 'Jean', 'jean.dupont@prothesiste.com', 'password123', NULL),
(2, 'Lemoine', 'Sophie', 'sophie.lemoine@prothesiste.com', 'securePass456', NULL),
(3, 'Charpentier', 'Luc', 'luc.charpentier@prothesiste.org', 'luc789Pass', NULL),
(4, 'Fournier', 'Isabelle', 'isabelle.fournier@prothesiste.net', 'Isabelle@2024', NULL),
(5, '[value-2]', '[value-3]', '[value-4]', '[value-5]', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `rendezvouss`
--

DROP TABLE IF EXISTS `rendezvouss`;
CREATE TABLE IF NOT EXISTS `rendezvouss` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int DEFAULT NULL,
  `date_rendezvous` date NOT NULL,
  `heure_rendezvous` time NOT NULL,
  `status` enum('en attente','confirmé','terminé','annulé') DEFAULT 'en attente',
  PRIMARY KEY (`id`),
  KEY `patient_id` (`patient_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `rendezvouss`
--

INSERT INTO `rendezvouss` (`id`, `patient_id`, `date_rendezvous`, `heure_rendezvous`, `status`) VALUES
(1, NULL, '2024-12-01', '12:52:46', 'terminé'),
(2, NULL, '2024-12-26', '14:52:46', 'confirmé');

-- --------------------------------------------------------

--
-- Structure de la table `secretaire`
--

DROP TABLE IF EXISTS `secretaire`;
CREATE TABLE IF NOT EXISTS `secretaire` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `stock_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `stock_id` (`stock_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `secretaire`
--

INSERT INTO `secretaire` (`id`, `nom`, `prenom`, `email`, `password`, `stock_id`) VALUES
(1, 'Martin', 'Clara', 'clara.martin@secretariat.com', 'password123', NULL),
(2, 'Lemoine', 'David', 'david.lemoine@secretariat.com', 'securePass456', NULL),
(3, 'Robert', 'Sophie', 'sophie.robert@secretariat.com', 'Sophie789Pass', NULL),
(4, 'Dufresne', 'Lucas', 'lucas.dufresne@secretariat.net', 'Lucas@2024', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `stock`
--

DROP TABLE IF EXISTS `stock`;
CREATE TABLE IF NOT EXISTS `stock` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom_produit` varchar(255) NOT NULL,
  `quantite` int NOT NULL,
  `prix_unitaire` decimal(10,2) NOT NULL,
  `date_ajout` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `stock`
--

INSERT INTO `stock` (`id`, `nom_produit`, `quantite`, `prix_unitaire`, `date_ajout`) VALUES
(1, 'Prothèse Dentaire', 50, 120.00, '2024-11-10'),
(2, 'Prothèse Orthopédique', 30, 200.00, '2024-11-12'),
(3, 'Vis Dentaire', 200, 2.50, '2024-11-15'),
(4, 'Implant Dentaire', 15, 350.00, '2024-12-01');

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `commander`
--
ALTER TABLE `commander`
  ADD CONSTRAINT `medecin_idd` FOREIGN KEY (`medecin_id`) REFERENCES `medecin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `prothesiste_id ` FOREIGN KEY (`prothesiste_id`) REFERENCES `prothesiste` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `consultation`
--
ALTER TABLE `consultation`
  ADD CONSTRAINT `medecin_id ` FOREIGN KEY (`medecin_id`) REFERENCES `medecin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `patient_id` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Contraintes pour la table `deal`
--
ALTER TABLE `deal`
  ADD CONSTRAINT `fournisseur_id` FOREIGN KEY (`fournisseur_id`) REFERENCES `fournisseur` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `secretaire_id` FOREIGN KEY (`secretaire_id`) REFERENCES `secretaire` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `liver`
--
ALTER TABLE `liver`
  ADD CONSTRAINT `livreur_id` FOREIGN KEY (`livreur_id`) REFERENCES `livreur` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `prothesiste_idd` FOREIGN KEY (`prothesiste_id`) REFERENCES `prothesiste` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `patient`
--
ALTER TABLE `patient`
  ADD CONSTRAINT `historique` FOREIGN KEY (`historique`) REFERENCES `historique_medical` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `rendez` FOREIGN KEY (`rendez`) REFERENCES `rendezvouss` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `prothesiste`
--
ALTER TABLE `prothesiste`
  ADD CONSTRAINT `fk_user_prothesiste` FOREIGN KEY (`prothese_id`) REFERENCES `prothese` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `secretaire`
--
ALTER TABLE `secretaire`
  ADD CONSTRAINT `stock_id` FOREIGN KEY (`stock_id`) REFERENCES `stock` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
