[![Docker Pulls](https://img.shields.io/docker/pulls/rdrit/glpi?logo=docker&label=Docker%20Hub)](https://hub.docker.com/r/rdrit/glpi) [![Docker Image Version](https://img.shields.io/docker/v/rdrit/glpi/latest?logo=docker&label=version)](https://hub.docker.com/r/rdrit/glpi) [![Docker Image Size](https://img.shields.io/docker/image-size/rdrit/glpi/latest?logo=docker&label=image%20size)](https://hub.docker.com/r/rdrit/glpi) [![Dockerfile](https://img.shields.io/badge/Dockerfile-View-blue?logo=docker)](https://git.rdr-it.com/dockerfile/glpi)

## 📦 Déploiement de GLPI avec Docker Compose

Environnement complet GLPI + MariaDB + Redis + Cron

Ce dépôt fournit une stack entièrement opérationnelle pour déployer GLPI via Docker, incluant :

* 🌐 GLPI Web [Docker hub](https://hub.docker.com/r/rdrit/glpi)
* 🗄️ MariaDB 11 optimisée
* ⚡ Redis pour le cache (optionnel)
* ⏱️ Cron GLPI (exécution automatique)

[docker-compose.yml](https://git.rdr-it.com/root/docker-compose/-/tree/main/GLPI)

## ⚙️ Prérequis

* Docker
* Docker Compose
* 2 CPU
* 4Go de Ram

## 🔧 Configuration (.env)

Le fichier .env permet de personnaliser toute la stack :

| Variable                  | Description                                 |
| ------------------------- | ------------------------------------------- |
| `GLPI_DOMAIN`             | Nom DNS du service GLPI                     |
| `GLPI_VERSION_INSTALL`    | Version GLPI installée au premier démarrage |
| `GLPI_DB_HOST`            | Nom du service MariaDB                      |
| `GLPI_DB_NAME`            | Nom de la base GLPI                         |
| `GLPI_DB_USER`            | Utilisateur de la base                      |
| `GLPI_DB_PASSWORD`        | Mot de passe utilisateur                    |
| `MYSQL_ROOT_PASSWORD`     | Mot de passe root MariaDB                   |
| `GLPI_REDIS_ENABLE`       | Yes/No - Activer Redis                      |
| `GLPI_REDIS_SERVER`       | Nom du service Redis                        |
| `GLPI_TIMEZONE`           | Fuseau horaire GLPI + MariaDB               |
| `GLPI_UPDATE_DB`          | Yes/No - Mise à jour DB automatique         |
| `GLPI_CHECK_REQUIREMENT`  | Yes/No - Vérification des prérequis GLPI    |
| `GLPI_TIMEZONE_CONFIG`    | Yes/No - Configuration timezone GLPI        |
| `PHP_MEMORY_LIMIT`        | Limite mémoire PHP                          |
| `PHP_UPLOAD_MAX_FILESIZE` | Taille max upload                           |
| `PHP_MAX_EXECUTION_TIME`  | Timeout PHP                                 |
| `RESTART_POLICY`          | Politique de redémarrage Docker             |
| `MARIADB_AUTO_UPGRADE`    | Mise à jour automatique des tables système  |

## 🚀 Démarrage

1️⃣ Cloner le dossier du dépot dans le dossier où vous souhaitez mettre le conteneur

```console
mkdir -p /containers/glpi
cd /contaienrs/glpi
bash <(wget -qO- https://git.rdr-it.com/root/scripts/-/raw/master/Linux/rdr-it/get-docker-compse/get.sh) GLPI
```
2️⃣ Modifier le fichier .env avec vos valeurs.

```console
nano .env
```

3️⃣ Lancer la stack :

```console
docker compose up -d
docker compose logs -f
```

4️⃣ Accéder à GLPI :

👉 http://GLPI\_DOMAIN

## 🏗️ Services

### 🔵 glpi-web

* Image : rdrit/glpi
* Expose le port 80 → 80
* Télécharge GLPI au premier démarrage si besoin
* Exécute automatiquement les mises à jour si GLPI\_UPDATE\_DB=Yes si une nouvelle version a été installé (installation manuelle dans le dossier ./data/glpi)
* Healthcheck intégré

### 🔵 glpi-cron

* Même image que GLPI
* Exécute automatiquement cron.php toutes les minutes

### 🟢 glpi-db

* Image : mariadb:11
* Optimisations avancées :
* *	InnoDB buffer : 1G
* * Log buffer : 256M
* * tmp_table_size/max_heap_table_size : 256M
* * Table cache : 4000
* Healthcheck officiel MariaDB

### 🔴 glpi-redis

* Image : redis:latest
* Healthcheck simple avec redis-cli ping

## 🗂️ Volumes

Les données sont stockées dans :

| Service | Chemin           |
| ------- | ---------------- |
| GLPI    | `./data/glpi`    |
| MariaDB | `./data/mariadb` |
