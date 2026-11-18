-- Compte MySQL dédié à l'API (droits minimaux), distinct du compte du site.
-- En développement uniquement : mots de passe factices, à changer en production.
CREATE DATABASE IF NOT EXISTS agence_voyage CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS 'api_voyages'@'%' IDENTIFIED BY 'api_dev_password';
-- Lecture/écriture des données (pas de DROP, pas de GRANT).
GRANT SELECT, INSERT, UPDATE, DELETE ON agence_voyage.* TO 'api_voyages'@'%';
-- Compte séparé pour appliquer les migrations (droits de structure).
CREATE USER IF NOT EXISTS 'api_migrations'@'%' IDENTIFIED BY 'migrations_dev_password';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, REFERENCES ON agence_voyage.* TO 'api_migrations'@'%';
FLUSH PRIVILEGES;
