# API Voyages sur mesure

API REST (JSON) qui expose de façon sécurisée les données du site de voyages sur mesure, en vue de la future application mobile. Projet BTS SIO SLAM — livraison le **30 novembre 2026**.

- **Auteur :** Jake Volante (BTS SIO 2 — 47 Ermitage)
- **Organisation :** travail seul (« chacun de son côté », § 2.1 du cahier des charges)
- **Technologie :** Symfony + API Platform (PHP 8.2+)
- **Suivi des tâches :** GitHub Project du dépôt (une tâche par user story + tâches transverses)

---

## 1. Choix de la technologie : Symfony + API Platform

J'ai choisi **Symfony (version LTS) avec API Platform** plutôt que FastAPI, pour quatre raisons liées au contexte de la cliente.

**1. La base de données existante.** L'API doit travailler sur la base MySQL du site, sans rien renommer ni supprimer. Doctrine permet de relier des entités à des tables existantes (noms de tables et de colonnes imposés) et de gérer les ajouts par des **migrations Doctrine versionnées**, ce que le cahier des charges demande (§ 6.3). Le hacheur de mots de passe de Symfony vérifie directement les empreintes `password_hash` de PHP (`$2y$`) : un membre inscrit sur le site pourra se connecter à l'API avec le même mot de passe, et un compte créé par l'API fonctionnera sur le site, sans bibliothèque supplémentaire.

**2. Le déploiement sur le serveur de la cliente.** Le serveur fait déjà tourner PHP et un serveur web (Apache ou Nginx) pour le site. Une API Symfony s'y ajoute **sans installer de nouveau logiciel** : `composer install --no-dev`, `APP_ENV=prod`, et le serveur web existant sert le dossier `public/` sur un sous-domaine `api.` ou sous `/api`. Avec FastAPI, il faudrait installer et maintenir Python 3.12, lancer un service supplémentaire (Uvicorn/Gunicorn via systemd) qui doit redémarrer seul et être surveillé, et configurer un proxy inverse : c'est un coût d'exploitation en plus pour une petite structure. Point à vérifier auprès de la cliente : la version de PHP du serveur doit convenir au site **et** à Symfony (PHP 8.2 minimum).

**3. L'équipe qui reprendra l'API.** L'équipe qui a développé le site travaille en **PHP**. Avec Symfony, elle reste dans son langage pour maintenir l'API et y ajouter des routes pour l'application mobile. Une API en Python l'obligerait à apprendre un nouveau langage et un nouvel écosystème.

**4. Les exigences de sécurité et de documentation.** API Platform fournit nativement ce que demande le cahier des charges : documentation OpenAPI générée automatiquement sur `/api/docs` (et export JSON), **groupes de sérialisation** pour contrôler précisément ce que chaque ressource renvoie et accepte (jamais de mot de passe ni d'empreinte), validation des entrées, pagination de toutes les listes. Symfony Security et `lexik/jwt-authentication-bundle` couvrent l'authentification par jeton JWT ; le limiteur de débit (RateLimiter) de Symfony couvre la limitation des tentatives de connexion et des simulations anonymes ; NelmioCorsBundle permet une liste blanche d'origines CORS. Enfin, j'ai déjà pratiqué Symfony en cours (projet Symfony et TP de sécurité), ce qui réduit le risque pour un projet réalisé seul en moins de deux semaines.

**Limite assumée :** Symfony est plus lourd à mettre en place que FastAPI au démarrage (configuration, entités). Je compense en utilisant les générateurs de Symfony (MakerBundle) et en commençant par l'environnement Docker Compose (API + copie de la base).

---

## 2. Organisation du travail

### Travail seul

Je réalise le projet **seul**, dans ce dépôt personnel. Conformément au § 2.1 :

- **Périmètre obligatoire (socle)** : les user stories sans ★ — API-01, 02, 03, 05, 06, 08, 09, 10, 11, 12, 13, 14.
- **Bonus** : les stories ★ — API-04, 07, 15 — réalisées seulement si le socle est terminé et testé.
- Le **contrat de l'API** (§ 6.1) et les **évolutions de la base** (§ 6.3) sont respectés à l'identique, pour que ma version soit interchangeable avec une autre.
- Une **branche par fonctionnalité** (`feature/API-01-connexion`, `feature/analyse-base`…), fusionnée dans `main` quand la tâche est terminée et testée.
- Chaque tâche du GitHub Project a un responsable (moi) et une date prévue (jalon).

### Contraintes de calendrier

Je suis en alternance : **au centre de formation du 16 au 20/11**, puis **en entreprise du 23 au 27/11**. Pendant la semaine en entreprise, je travaillerai sur le projet le soir et le week-end ; le planning en tient compte (étapes plus courtes cette semaine-là).

### Étapes intermédiaires jusqu'au 30 novembre

| Étape | Date prévue | Contenu | Résultat vérifiable |
|---|---|---|---|
| 0. Cadrage | mer. 18/11 | Dépôt, GitHub Project, README (choix + organisation) | Dépôt et Project en ligne |
| 1. Analyse et conception | ven. 20/11 | Analyse de `database/install.sql` et écarts avec le MLD, MCD/MLD mis à jour, environnement Docker Compose, diagrammes UML, **fiche E6** | Écarts notés dans ce README, fiche E6 envoyée |
| 2. Socle : authentification et référentiels | dim. 22/11 | Migrations (statut, consentement, code de reprise, rôle, compte actif, échecs de connexion), API-05, API-01, API-02, API-03 | Connexion JWT fonctionnelle avec un compte du site |
| 3. Simulations du membre | mer. 25/11 | API-06, API-08, API-09, API-10 | Simulation rapide + simulations détaillées testées |
| 4. Espace gérante | ven. 27/11 | API-11, API-12, API-13, API-14 | Routes gérante protégées (403 pour un membre) |
| 5. Recette et documentation | dim. 29/11 | Tests de recette (§ 11), export OpenAPI JSON, fichier de requêtes, fiche de sécurité, guide de déploiement, dossier de reprise | Tous les tests passent |
| 6. Livraison | lun. 30/11 | Étiquette `v1.0`, envoi du lien du dépôt | Version livrée |

Les bonus ★ (API-07, puis API-15, puis API-04) ne sont commencés qu'après l'étape 4, s'il reste du temps avant le 29/11.

### Si je prends du retard

1. **Je fais un point à la fin de chaque étape** : si une étape n'est pas terminée à sa date, je l'indique dans le GitHub Project et j'ajuste la suivante.
2. **J'abandonne d'abord les bonus ★** : ils ne sont pas obligatoires quand on travaille seul.
3. **Je garde toujours la sécurité dans le socle** (JWT, contrôle d'accès, validation, aucune empreinte renvoyée) : une route livrée doit être sécurisée, quitte à livrer moins de routes.
4. **Je réduis la documentation au minimum exigé** plutôt que de sauter les tests de recette.
5. **Je préviens l'enseignante dès qu'un blocage dure plus d'une journée**, et au plus tard le mercredi 25/11 si la livraison complète du socle me paraît compromise — pas la veille de la livraison.
6. Quoi qu'il arrive, **une version est étiquetée `v1.0` et envoyée le 30/11**, avec la liste de ce qui n'est pas terminé dans le dossier de reprise (section « Limites »).

---

## 3. Écarts entre le MLD et la base réelle

> **Analyse en cours (18/11).** Faite à partir du code source du site fourni (`SITE_VITRINE_VOYAGE_POC`), en attendant l'export SQL de la base réelle. Les points marqués ⚠️ sont à confirmer sur la base.

### 3.1 Constat général

- **Le site n'est plus en PHP procédural** comme l'indique le cahier des charges : il a été refondu en **Symfony 7 + Doctrine** (le README du site parle d'une « reprise complète du projet PHP procédural »). C'est un argument de plus pour Symfony : l'API pourra reprendre les mêmes conventions et le même hacheur de mots de passe.
- **Pas de `database/install.sql` dans le dépôt du site.** La seule migration (`Version20260827000000`, « équivalent de l'ancien install.sql ») crée des tables `users` et `simulations` **qui ne correspondent pas aux entités du site** (`utilisateur`, `simulation`, …). ⚠️ Le vrai schéma est celui mappé par les entités Doctrine ; il faut un export SQL de la base (phpMyAdmin / `mysqldump`) pour le confirmer.

### 3.2 Comparaison table par table

| MLD du cahier des charges | Base du site (entités Doctrine) | Écart |
|---|---|---|
| `Visiteur` (idTechnique, idVisiteur, login, mdp, contact) | `utilisateur` (IdUser, Nom, Login, Password, Role, Date_inscription, Contact, Telephone) | Table renommée ; `Login` contient l'**e-mail** ; ajout de Nom, Role, Date_inscription, Telephone |
| `Simulation` (id, dateSoumission, budget, période, styleVoyage, flexibilité, participants, #idVisiteurTechnique) | `simulation` (IdSimulation, #IdUser **nullable**, #IdDestination, #IdTheme, #IdLogement, #IdTransport, #IdTypeSejour, Date_soumission, Date_Depart, Date_Retour, Budget, Ville_Depart, Ville_Retour, Besoin_Specifique, Attentes, Animaux, Statut, Date_Envoie) | Une seule destination et un seul thème par clé étrangère ; pas de flexibilité ni de style ; période remplacée par deux dates ; participants détaillés dans `inclu_voyageur` |
| `Inclusion` (id, priorité, #idSimulation, #idDestination, #idTheme, #idTypeActivité) | `inclu_type` (IdSimulation, IdType) | **Pas de priorité**, pas de destinations multiples : seule la liaison simulation ↔ type d'activité existe |
| `Destination` (id, pays, ville) | `destination` (IdDestination, Ville, Region) | **Pas de pays**, une région à la place |
| `Theme` (id, theme) | `theme` (IdTheme, Theme) | Conforme |
| `TypeActivite` (id, type) | `type_activite` (IdType, Type) | Conforme |
| — | `logement`, `transport`, `type_sejour`, `voyageur`, `inclu_voyageur` | Tables absentes du MLD |

### 3.3 Les trois points demandés (§ 3.1 du cahier des charges)

1. **Mots de passe** : hachés par Symfony (`password_hashers: auto`, bcrypt `$2y$`). Compatible avec `password_hash()` de PHP et avec le hacheur de l'API.
2. **Statut d'une simulation** : **existe** (`simulation.Statut`, ENUM ⚠️ `en_attente`, `validé`, `refusé`). Les statuts attendus par l'API (brouillon, envoyée, en discussion, devis envoyé, clôturée) sont différents : correspondance à définir sans casser le site.
3. **Rôle de la gérante** : **existe en base** (`utilisateur.Role` = `user` / `admin`), contrairement au cahier des charges qui parle d'un `.htpasswd`. **Consentement au rappel** : **absent** (la case RGPD est vérifiée par le formulaire mais pas enregistrée).

### 3.4 Conséquences pour l'API

- **La simulation rapide n'est pas enregistrée en base** par le site (elle est gardée en session). Comme `simulation` impose une destination, un thème, un logement, un transport et un type de séjour, une simulation anonyme ne peut pas y être stockée sans modifier des colonnes existantes → piste : **nouvelle table `simulation_rapide`** (ajout uniquement), rattachée ensuite avec le code de reprise.
- Ajouts à prévoir (migrations) : consentement au rappel + date, code de reprise (empreinte), compte actif, nombre d'échecs de connexion, statuts de l'API ⚠️ (extension de l'ENUM ou table de correspondance, à valider pour ne pas casser le site).
- Le rôle `admin` existant sera réutilisé comme rôle **gérante** (`ROLE_ADMIN`), sans nouvelle colonne.

## 4. Installation en développement

*À compléter (Docker Compose : API + MySQL avec une copie de la base du site).*

## 5. Comptes de test

*À compléter.*

## 6. Lancement des tests

*À compléter (PHPUnit + client de test d'API Platform).*
