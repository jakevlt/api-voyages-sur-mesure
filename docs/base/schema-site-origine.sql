-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : jeu. 10 sep. 2026 à 16:25
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `agence_voyage`
--

-- --------------------------------------------------------

--
-- Structure de la table `destination`
--

CREATE TABLE `destination` (
  `IdDestination` int(11) NOT NULL,
  `Ville` varchar(100) NOT NULL,
  `Region` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `inclu_type`
--

CREATE TABLE `inclu_type` (
  `IdSimulation` int(11) NOT NULL,
  `IdType` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `inclu_voyageur`
--

CREATE TABLE `inclu_voyageur` (
  `IdSimulation` int(11) NOT NULL,
  `IdVoyageur` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `logement`
--

CREATE TABLE `logement` (
  `IdLogement` int(11) NOT NULL,
  `Type_Logement` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `simulation`
--

CREATE TABLE `simulation` (
  `IdSimulation` int(11) NOT NULL,
  `Date_soumission` date NOT NULL,
  `Budget` decimal(10,2) DEFAULT NULL,
  `Date_Depart` date DEFAULT NULL,
  `Date_Retour` date DEFAULT NULL,
  `Type_Sejour` varchar(100) DEFAULT NULL,
  `Ville_Depart` varchar(100) DEFAULT NULL,
  `Ville_Retour` varchar(100) DEFAULT NULL,
  `IdUser` int(11) DEFAULT NULL,
  `IdDestination` int(11) NOT NULL,
  `IdTheme` int(11) NOT NULL,
  `IdLogement` int(11) NOT NULL,
  `IdTransport` int(11) NOT NULL,
  `Besoin_Specifique` tinyint(1) DEFAULT NULL,
  `Attentes` text DEFAULT NULL,
  `Statut` enum('en_attente','validé','refusé') NOT NULL DEFAULT 'en_attente',
  `Date_Envoie` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `theme`
--

CREATE TABLE `theme` (
  `IdTheme` int(11) NOT NULL,
  `Theme` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `transport`
--

CREATE TABLE `transport` (
  `IdTransport` int(11) NOT NULL,
  `Type_Transport` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `type_activite`
--

CREATE TABLE `type_activite` (
  `IdType` int(11) NOT NULL,
  `Type` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE `utilisateur` (
  `IdUser` int(11) NOT NULL,
  `Login` varchar(50) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Contact` varchar(150) DEFAULT NULL,
  `Nom` varchar(100) NOT NULL,
  `Role` enum('admin','user') NOT NULL DEFAULT 'user',
  `Date_inscription` date NOT NULL,
  `Telephone` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `voyageur`
--

CREATE TABLE `voyageur` (
  `IdVoyageur` int(11) NOT NULL,
  `Type_Voyageur` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `destination`
--
ALTER TABLE `destination`
  ADD PRIMARY KEY (`IdDestination`);

--
-- Index pour la table `inclu_type`
--
ALTER TABLE `inclu_type`
  ADD PRIMARY KEY (`IdSimulation`,`IdType`),
  ADD KEY `fk_inclutype_type` (`IdType`);

--
-- Index pour la table `inclu_voyageur`
--
ALTER TABLE `inclu_voyageur`
  ADD PRIMARY KEY (`IdSimulation`,`IdVoyageur`),
  ADD KEY `fk_incluvoyageur_voyageur` (`IdVoyageur`);

--
-- Index pour la table `logement`
--
ALTER TABLE `logement`
  ADD PRIMARY KEY (`IdLogement`);

--
-- Index pour la table `simulation`
--
ALTER TABLE `simulation`
  ADD PRIMARY KEY (`IdSimulation`),
  ADD KEY `fk_simulation_user` (`IdUser`),
  ADD KEY `fk_simulation_destination` (`IdDestination`),
  ADD KEY `fk_simulation_theme` (`IdTheme`),
  ADD KEY `fk_simulation_logement` (`IdLogement`),
  ADD KEY `fk_simulation_transport` (`IdTransport`);

--
-- Index pour la table `theme`
--
ALTER TABLE `theme`
  ADD PRIMARY KEY (`IdTheme`);

--
-- Index pour la table `transport`
--
ALTER TABLE `transport`
  ADD PRIMARY KEY (`IdTransport`);

--
-- Index pour la table `type_activite`
--
ALTER TABLE `type_activite`
  ADD PRIMARY KEY (`IdType`);

--
-- Index pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD PRIMARY KEY (`IdUser`),
  ADD UNIQUE KEY `Login` (`Login`);

--
-- Index pour la table `voyageur`
--
ALTER TABLE `voyageur`
  ADD PRIMARY KEY (`IdVoyageur`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `destination`
--
ALTER TABLE `destination`
  MODIFY `IdDestination` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `logement`
--
ALTER TABLE `logement`
  MODIFY `IdLogement` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `simulation`
--
ALTER TABLE `simulation`
  MODIFY `IdSimulation` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `theme`
--
ALTER TABLE `theme`
  MODIFY `IdTheme` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `transport`
--
ALTER TABLE `transport`
  MODIFY `IdTransport` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `type_activite`
--
ALTER TABLE `type_activite`
  MODIFY `IdType` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `IdUser` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `voyageur`
--
ALTER TABLE `voyageur`
  MODIFY `IdVoyageur` int(11) NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `inclu_type`
--
ALTER TABLE `inclu_type`
  ADD CONSTRAINT `fk_inclutype_simulation` FOREIGN KEY (`IdSimulation`) REFERENCES `simulation` (`IdSimulation`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inclutype_type` FOREIGN KEY (`IdType`) REFERENCES `type_activite` (`IdType`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `inclu_voyageur`
--
ALTER TABLE `inclu_voyageur`
  ADD CONSTRAINT `fk_incluvoyageur_simulation` FOREIGN KEY (`IdSimulation`) REFERENCES `simulation` (`IdSimulation`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_incluvoyageur_voyageur` FOREIGN KEY (`IdVoyageur`) REFERENCES `voyageur` (`IdVoyageur`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `simulation`
--
ALTER TABLE `simulation`
  ADD CONSTRAINT `fk_simulation_destination` FOREIGN KEY (`IdDestination`) REFERENCES `destination` (`IdDestination`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_simulation_logement` FOREIGN KEY (`IdLogement`) REFERENCES `logement` (`IdLogement`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_simulation_theme` FOREIGN KEY (`IdTheme`) REFERENCES `theme` (`IdTheme`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_simulation_transport` FOREIGN KEY (`IdTransport`) REFERENCES `transport` (`IdTransport`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_simulation_user` FOREIGN KEY (`IdUser`) REFERENCES `utilisateur` (`IdUser`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
