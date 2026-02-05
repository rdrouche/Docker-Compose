# Nextcloud + OnlyOffice avec Docker Compose

Ce dépôt permet de déployer une instance Nextcloud complète avec :

- Base de données MariaDB
- Cache Redis
- Tâches planifiées via cron
- Intégration OnlyOffice Document Server
- Configuration via fichier .env
- Persistance des données via volumes Docker

Le tout est orchestré avec Docker Compose.

## 📦 Architecture

Les services déployés :

- **nextcloud_app** : application Nextcloud (HTTP/HTTPS)
- **nextcloud_db** : base de données MariaDB optimisée pour Nextcloud
- **nextcloud_redis** : cache Redis pour les verrous et performances
- **nextcloud_cron** : exécution des tâches cron Nextcloud
- **onlyoffice-document-server** : édition collaborative de documents

## ⚙️ Pré-requis

- Docker
- Docker Compose
- Un reverse proxy (optionnel mais recommandé)
- Un nom de domaine pour Nextcloud et OnlyOffice

## 📄 Tableau des variables d’environnement (.env)

| **Variable**                      | **Requise?** | **Description**                                                           | **Exemple / Valeur typique**    |
| --------------------------------- | :----------: | ------------------------------------------------------------------------- | ------------------------------- |
| **NEXTCLOUD_MYSQL_DATABASE**      |       ✅      | Nom de la base de données que MariaDB doit créer pour Nextcloud           | `nextcloud`                     |
| **NEXTCLOUD_MYSQL_USER**          |       ✅      | Utilisateur MariaDB pour Nextcloud                                        | `nextcloud`                     |
| **NEXTCLOUD_MYSQL_PASSWORD**      |       ✅      | Mot de passe de l’utilisateur MariaDB Nextcloud                           | `MySecretNextcloudUserPassword` |
| **NEXTCLOUD_MYSQL_ROOT_PASSWORD** |       ✅      | Mot de passe administrateur de MariaDB                                    | `MySecretRootPassword`          |
| **NEXTCLOUD_HTTP_PORT**           |       ✅      | Port HTTP exposé sur l’hôte (si pas de reverse proxy)                     | `80`                            |
| **NEXTCLOUD_HTTPS_PORT**          |       ❌      | Port HTTPS exposé sur l’hôte (si pas de reverse proxy)                    | `443`                           |
| **NEXTCLOUD_REDIS_HOST**          |       ✅      | Adresse/nom du service Redis utilisé par Nextcloud                        | `nextcloud_redis`               |
| **NEXTCLOUD_SMTP_HOST**           |       ❌      | Serveur SMTP pour l’envoi d’e‑mails depuis Nextcloud                      | `smtp.server.dom`               |
| **NEXTCLOUD_MAIL_FROM**           |       ❌      | Adresse e‑mail affichée comme expéditeur                                  | `next@my.dom`                   |
| **NEXTCLOUD_OVERWRITEHOST**       |       ✅      | Nom de domaine public de Nextcloud (overwritehost pour reverse proxy/URL) | `nextcloud.my.dom`              |
| **NEXTCLOUD_OVERWRITEPROTOCOL**   |       ✅      | Protocole utilisé publiquement : `http` ou `https`                        | `https`                         |
| **NEXTCLOUD_OVERWRITECLIURL**     |       ✅      | URL complète publique utilisée par la CLI Nextcloud                       | `https://nextcloud.my.dom`      |
| **OL_HTTP_PORT**                  |       ✅      | Port HTTP exposé pour OnlyOffice                                          | `8080`                          |
| **OL_HTTPS_PORT**                 |       ✅      | Port HTTPS exposé pour OnlyOffice                                         | `8443`                          |
| **OL_JWT_SECRET**                 |       ✅      | Clé secrète partagée entre Nextcloud & OnlyOffice pour JWT                | `CHANGEMEONLYOFFICEJWTSECRET`   |

