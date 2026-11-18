-- Données de TEST pour le développement (aucune donnée réelle).
-- Chargées automatiquement au premier démarrage du conteneur MariaDB,
-- APRÈS le schéma d'origine du site et AVANT les migrations de l'API.
-- Mots de passe des comptes de test : voir README (section « Comptes de test »).
SET NAMES utf8mb4;
USE agence_voyage;

INSERT INTO destination (IdDestination, Ville, Region) VALUES
 (1,'Lisbonne','Europe'), (2,'Barcelone','Europe'), (3,'Rome','Europe'),
 (4,'Marrakech','Afrique'), (5,'Le Cap','Afrique'),
 (6,'Kyoto','Asie'), (7,'Bangkok','Asie'),
 (8,'Montréal','Amérique'), (9,'Cusco','Amérique');

INSERT INTO theme (IdTheme, Theme) VALUES
 (1,'Tranquille'), (2,'Équilibré'), (3,'Intense');

INSERT INTO type_activite (IdType, Type) VALUES
 (1,'Randonnée'), (2,'Musées et patrimoine'), (3,'Plage'), (4,'Gastronomie'),
 (5,'Sports nautiques'), (6,'Vie nocturne'), (7,'Activités pour enfants');

INSERT INTO logement (IdLogement, Type_Logement) VALUES
 (1,'Hôtel'), (2,'Location'), (3,'Gîte'), (4,'Camping'), (5,'Chez l''habitant');

INSERT INTO transport (IdTransport, Type_Transport) VALUES
 (1,'Avion'), (2,'Train'), (3,'Voiture'), (4,'Bus'), (5,'Bateau');

INSERT INTO voyageur (IdVoyageur, Type_Voyageur) VALUES
 (1,'Bébé'), (2,'Enfant'), (3,'Adulte'), (4,'Senior');

-- Comptes de test (empreintes bcrypt $2y$, comme le site)
INSERT INTO utilisateur (IdUser, Login, Password, Contact, Nom, Role, Date_inscription, Telephone) VALUES
 (1,'gerante@test.local','$2y$13$MGynvJu.ue/wEASQdTJH8OD.CSA3OUnI8Of85/wTa9acNpFmaV8f6',NULL,'Gérante Test','admin','2026-06-01',NULL),
 (2,'membre@test.local','$2y$13$GN/AM2FUnQUUNvzjU/hvBe7LXwZWql1X3sepEjDzH9b08t8KrruBi','membre@test.local','Membre Test','user','2026-09-01','0601020304'),
 (3,'membre2@test.local','$2y$13$TUGGNt2sXe9OpGvwDlTAUev.74n31YT7c7BjkHpkciyoEt0F0zB5u',NULL,'Autre Membre','user','2026-09-15',NULL);

-- Simulations de test (format de la base d'origine, avant réparation)
INSERT INTO simulation (IdSimulation, Date_soumission, Budget, Date_Depart, Date_Retour, Type_Sejour, Ville_Depart, Ville_Retour,
                        IdUser, IdDestination, IdTheme, IdLogement, IdTransport, Besoin_Specifique, Attentes, Statut, Date_Envoie) VALUES
 (1,'2026-09-05',1800.00,'2027-04-10','2027-04-17','Détente','Bordeaux','Lisbonne',2,1,1,1,1,0,'Un hôtel près de la mer','en_attente','2026-09-05'),
 (2,'2026-09-20',3200.00,'2027-07-01','2027-07-15','Aventure','Bordeaux','Cusco',2,9,3,3,1,1,'Randonnées encadrées','validé','2026-09-20'),
 (3,'2026-10-02',950.00,'2027-02-14','2027-02-18','Culturel','Agen','Rome',3,3,2,1,2,NULL,NULL,'en_attente','2026-10-02');

INSERT INTO inclu_type (IdSimulation, IdType) VALUES (1,3),(1,4),(2,1),(3,2),(3,4);
INSERT INTO inclu_voyageur (IdSimulation, IdVoyageur) VALUES (1,3),(2,3),(2,2),(3,3);
