-- Comptes MySQL dédiés à l'API (droits minimaux), distincts du compte du site (§ 6.3 du cahier des charges).
-- À exécuter une fois dans phpMyAdmin (onglet SQL) sur la base site_vitrine.
-- Mots de passe de développement uniquement : à changer en production.
CREATE USER IF NOT EXISTS 'api_voyages'@'localhost' IDENTIFIED BY 'api_dev_password';
-- Lecture/écriture des données (pas de DROP, pas de GRANT).
GRANT SELECT, INSERT, UPDATE, DELETE ON site_vitrine.* TO 'api_voyages'@'localhost';
-- Compte séparé pour appliquer les migrations (droits de structure).
CREATE USER IF NOT EXISTS 'api_migrations'@'localhost' IDENTIFIED BY 'migrations_dev_password';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, REFERENCES ON site_vitrine.* TO 'api_migrations'@'localhost';
FLUSH PRIVILEGES;
