<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Réparation de la base `agence_voyage` pour qu'elle corresponde au code du site.
 *
 * Le code du site (entités Doctrine) utilise des éléments absents de la base réelle
 * (export du 10/09/2026), ce qui fait planter le simulateur complet :
 *   1. table `type_sejour` + colonne `simulation.IdTypeSejour` ;
 *   2. colonne `simulation.Animaux` ;
 *   3. colonne `inclu_voyageur.nbre_voyageur` ;
 *   4. `simulation.Besoin_Specifique` est un booléen alors que le site y écrit un texte.
 *
 * Les points 1 à 3 sont des AJOUTS (règle du § 6.3 du cahier des charges).
 * Le point 4 est la seule modification de type : TINYINT(1) -> TEXT, sans perte de données
 * (voir README, section 3.6). Le code du site n'est pas modifié.
 */
final class Version20261118120000 extends AbstractMigration
{
    public function getDescription(): string
    {
        return 'Réparation : type_sejour, Animaux, nbre_voyageur, Besoin_Specifique en texte';
    }

    public function up(Schema $schema): void
    {
        // 1. Table des types de séjour (lue par la liste déroulante du simulateur complet).
        $this->addSql(<<<'SQL'
            CREATE TABLE type_sejour (
                IdTypeSejour INT(11) NOT NULL AUTO_INCREMENT,
                Type_Sejour VARCHAR(100) NOT NULL,
                PRIMARY KEY (IdTypeSejour),
                UNIQUE KEY uniq_type_sejour (Type_Sejour)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci
        SQL);

        // Valeurs déjà saisies dans l'ancienne colonne texte simulation.Type_Sejour.
        $this->addSql(<<<'SQL'
            INSERT IGNORE INTO type_sejour (Type_Sejour)
            SELECT DISTINCT TRIM(Type_Sejour) FROM simulation
            WHERE Type_Sejour IS NOT NULL AND TRIM(Type_Sejour) <> ''
        SQL);

        // Liste de départ pour que le formulaire ne soit pas vide (modifiable par la gérante).
        $this->addSql(<<<'SQL'
            INSERT IGNORE INTO type_sejour (Type_Sejour) VALUES
            ('Détente'), ('Aventure'), ('Culturel'), ('Nature'), ('Gastronomie')
        SQL);

        // Clé étrangère vers type_sejour (nullable : les anciennes simulations n'en ont pas forcément).
        $this->addSql('ALTER TABLE simulation ADD IdTypeSejour INT(11) DEFAULT NULL');
        $this->addSql('ALTER TABLE simulation ADD KEY fk_simulation_type_sejour (IdTypeSejour)');
        $this->addSql(<<<'SQL'
            ALTER TABLE simulation ADD CONSTRAINT fk_simulation_type_sejour
            FOREIGN KEY (IdTypeSejour) REFERENCES type_sejour (IdTypeSejour) ON UPDATE CASCADE
        SQL);

        // Reprise des anciennes simulations : texte -> identifiant.
        // L'ancienne colonne Type_Sejour est conservée (on ne supprime rien).
        $this->addSql(<<<'SQL'
            UPDATE simulation s
            JOIN type_sejour t ON t.Type_Sejour = TRIM(s.Type_Sejour)
            SET s.IdTypeSejour = t.IdTypeSejour
            WHERE s.IdTypeSejour IS NULL
        SQL);

        // 2. Animaux voyageant avec le groupe (texte libre, 100 caractères max côté site).
        $this->addSql('ALTER TABLE simulation ADD Animaux VARCHAR(100) DEFAULT NULL');

        // 3. Nombre de voyageurs par catégorie (ex : 2 adultes, 1 enfant).
        $this->addSql('ALTER TABLE inclu_voyageur ADD nbre_voyageur INT(11) NOT NULL DEFAULT 1');

        // 4. Besoins spécifiques : booléen -> texte (le site y enregistre la description).
        //    Les valeurs existantes sont converties pour garder leur sens à l'affichage.
        $this->addSql('ALTER TABLE simulation MODIFY Besoin_Specifique TEXT DEFAULT NULL');
        $this->addSql("UPDATE simulation SET Besoin_Specifique = NULL WHERE Besoin_Specifique = '0'");
        $this->addSql(<<<'SQL'
            UPDATE simulation SET Besoin_Specifique = 'Oui (détail non renseigné)'
            WHERE Besoin_Specifique = '1'
        SQL);
    }

    public function down(Schema $schema): void
    {
        // Retour arrière. Attention : le texte des besoins spécifiques est ramené à 0/1
        // (perte du détail) -> faire une sauvegarde de la base avant.
        $this->addSql(<<<'SQL'
            UPDATE simulation SET Besoin_Specifique =
                CASE WHEN Besoin_Specifique IS NULL OR Besoin_Specifique = '' THEN NULL ELSE '1' END
        SQL);
        $this->addSql('ALTER TABLE simulation MODIFY Besoin_Specifique TINYINT(1) DEFAULT NULL');
        $this->addSql('ALTER TABLE inclu_voyageur DROP COLUMN nbre_voyageur');
        $this->addSql('ALTER TABLE simulation DROP COLUMN Animaux');
        $this->addSql('ALTER TABLE simulation DROP FOREIGN KEY fk_simulation_type_sejour');
        $this->addSql('ALTER TABLE simulation DROP KEY fk_simulation_type_sejour');
        $this->addSql('ALTER TABLE simulation DROP COLUMN IdTypeSejour');
        $this->addSql('DROP TABLE type_sejour');
    }
}
