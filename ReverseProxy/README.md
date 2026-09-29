# Nginx Reverse Proxy Stack

Docker Compose stack for deploying an **Nginx reverse proxy with Nginx Control**.

This repository contains the files required to deploy a complete Nginx reverse proxy environment, including:

* Nginx
* Nginx Control
* SSL certificates
* Let's Encrypt / Certbot
* GeoIP data
* Nginx logs and cache
* GoAccess
* Nginx Analyzer
* Local configuration backups
* Git-based configuration management

The stack is designed to work with **Nginx Control** and keeps the standard Nginx configuration structure.

## 🌐 Project

* **Nginx Control website:** https://nginx-control.rdr-it.com
* **Nginx Control documentation:** https://docs.nginx-control.rdr-it.com/
* **Nginx Control source code:** https://forge.rdr-it.com/Nginx/nginx-control
* **This deployment repository:** https://forge.rdr-it.com/romain/Docker-Compose/src/branch/main/ReverseProxy

## 🏗️ Architecture

The stack is composed of two main containers:

```text
                         Internet / LAN
                               │
                               ▼
                    ┌─────────────────────┐
                    │        Nginx        │
                    │   Reverse Proxy     │
                    │                     │
                    │  HTTP / HTTPS       │
                    │  VHosts              │
                    │  SSL                │
                    └──────────┬──────────┘
                               │
                    ┌──────────┴──────────┐
                    │                     │
                    ▼                     ▼
              Applications          Nginx Control
                                    Dashboard / API
                                         │
                 ┌───────────────────────┼──────────────────────┐
                 │                       │                      │
                 ▼                       ▼                      ▼
              Docker                  GitOps                GoAccess
              Socket                 Configuration           Analyzer
```

Both Nginx and Nginx Control are connected to the `nginx-net` Docker network.

Nginx Control also has access to the Docker socket in order to provide Docker-related features and Nginx container control.

## 📂 Directory structure

The stack uses bind mounts so that the configuration and data remain directly accessible on the host.

```text
ReverseProxy/
├── compose.yml
├── sample.env
├── nginx-dashboard.env
│
├── nginx/
│   ├── config/
│   │   ├── conf.d/
│   │   ├── sites/
│   │   ├── snippets/
│   │   └── streams/
│   ├── webroot/
│   ├── logs/
│   └── cache/
│
├── certificats/
│   ├── ssl/
│   └── certbot/
│
├── geoip_data/
│
├── config/
│   └── nginx-dashboard/
│       ├── config/
│       └── goaccess/
│
└── backups/
```

The configuration structure follows the standard organization used by Nginx Control:

* `nginx/config/conf.d/` — global HTTP configuration
* `nginx/config/sites/` — virtual hosts
* `nginx/config/snippets/` — reusable configuration snippets
* `nginx/config/streams/` — TCP/UDP stream configuration
* `nginx/logs/` — Nginx logs
* `nginx/cache/` — Nginx cache
* `certificats/ssl/` — manually managed SSL certificates
* `certificats/certbot/` — Let's Encrypt / Certbot data
* `geoip_data/` — GeoIP databases
* `config/nginx-dashboard/` — Nginx Control configuration and GoAccess data
* `backups/` — local configuration backups

## 🚀 Deployment

### Requirements

You need:

* Docker
* Docker Compose
* A Linux server
* Ports `80` and `443` available for Nginx

Clone or copy this directory to your server.

For example:

```bash
mkdir -p /containers/reverse-proxy
cd /containers/reverse-proxy
```

### Configure the environment

Copy the sample environment file:

```bash
cp sample.env .env
```

Edit the values according to your environment.

The main parameters include:

```dotenv
RESTART_POLICY=always
NGINX_NETWORK=nginx-net

NGINX_TAG=1.30.5
NGINX_CONTAINER_NAME=nginx
NGINX_WORKER_PROCESSES=auto
NGINX_WORKER_CONNECTIONS=768

NGX_DHB_CONTAINER_NAME=nginx-dashboard
```

The stack uses version tags for both the Nginx image and the Nginx Control image, which can be overridden through the `.env` file.

## ▶️ Start the stack

Start the stack with:

```bash
docker compose up -d
```

Check the containers:

```bash
docker compose ps
```

View the logs:

```bash
docker compose logs -f
```

Nginx automatically validates its configuration when starting.

If the configuration is invalid, check the Nginx container logs:

```bash
docker compose logs nginx
```

## ⚙️ Customizing the deployment

The main `compose.yml` file is intended to remain as close as possible to the upstream stack definition.

For local customizations, use Docker Compose's override mechanism.

Create:

```text
compose.override.yml
```

For example, to publish Nginx Control directly on a local port:

```yaml
services:
  nginx-dashboard:
    ports:
      - "3000:3000"
```

Then start the stack normally:

```bash
docker compose up -d
```

Docker Compose automatically merges `compose.yml` and `compose.override.yml`.

This makes it possible to customize:

* Ports
* Volumes
* Networks
* Environment variables
* Resource limits
* Additional services

without modifying the main stack file.

## 🔐 SSL certificates

The stack provides two locations for certificates:

```text
certificats/
├── ssl/
└── certbot/
```

### Manual certificates

Certificates can be placed in:

```text
certificats/ssl/
```

They are available inside the Nginx container under:

```text
/ssl
```

Example:

```nginx
server {
    listen 443 ssl;
    server_name example.com;

    ssl_certificate /ssl/example.com.crt;
    ssl_certificate_key /ssl/example.com.key;

    location / {
        proxy_pass http://backend:80;
    }
}
```

### Let's Encrypt / Certbot

Certbot data is stored in:

```text
certificats/certbot/
```

and mounted inside the Nginx container as:

```text
/etc/letsencrypt
```

This follows the standard Certbot directory structure and makes certificate management easier to migrate or reuse.

For complete certificate management instructions, see the Nginx Control documentation.

## 🧩 Nginx configuration

Nginx configuration files are stored directly on the host.

```text
nginx/config/
├── conf.d/
├── sites/
├── snippets/
└── streams/
```

This allows you to edit the configuration using your preferred editor, Git, or Nginx Control.

For example:

```text
nginx/config/sites/example.com.conf
```

```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://192.168.1.10:8080;
    }
}
```

After modifying the configuration, Nginx can be tested and reloaded through Nginx Control.

## 🐳 Docker network

The stack creates the following Docker network:

```text
nginx-net
```

Applications that need to be published through Nginx can be connected to this network.

For example:

```yaml
services:
  web:
    image: nginx:alpine
    networks:
      - nginx-net

networks:
  nginx-net:
    external: true
```

This allows Nginx to communicate directly with the application container using its Docker service name.

Nginx Control can also use this network for its Docker auto-configuration features.

## 🤖 Docker auto-configuration

Nginx Control supports automatic publication of Docker containers through Docker labels.

Example:

```yaml
labels:
  - "nginx-control.enable=true"
  - "nginx-control.vhost.server_name=app.example.com"
  - "nginx-control.vhost.location01=/"
  - "nginx-control.vhost.location01.proxy_pass=http://web:80"
  - "nginx-control.network=nginx-net"
```

The container can then be detected by Nginx Control and published through an automatically generated Nginx Virtual Host.

See the Nginx Control documentation for the complete label reference and remote Docker agent configuration.

## 📊 Monitoring and logs

The stack provides the directories required by Nginx Control for monitoring and analysis:

```text
nginx/logs/
nginx/cache/
geoip_data/
config/nginx-dashboard/goaccess/
```

These are used by features such as:

* Real-time Nginx logs
* Nginx Analyzer
* GoAccess
* GeoIP analysis
* Cache management
* Backend monitoring

## 💾 Backups

Nginx Control can create local configuration backups.

They are stored in:

```text
backups/
```

The directory is mounted into Nginx Control as:

```text
/nginx/backups
```

This allows configuration backups to remain available independently of the container lifecycle.

## 🔄 GitOps

Nginx Control can use a Git repository as the source of truth for Nginx configuration.

The following configuration directories can be managed through Git:

```text
nginx/config/conf.d/
nginx/config/sites/
nginx/config/snippets/
nginx/config/streams/
certificats/ssl/
```

This allows you to version:

* Virtual Hosts
* Nginx global configuration
* Snippets
* Stream configurations
* SSL certificates

and deploy validated configurations through Nginx Control.

See the documentation for the complete GitOps configuration.

## 🔧 Updating the stack

To update the stack, modify the image versions in `.env`.

For example:

```dotenv
NGINX_TAG=1.30.5
NGX_DHB_TAG=x.x.x
```

Then recreate the containers:

```bash
docker compose pull
docker compose up -d
```

The configuration and data stored in the bind-mounted directories are preserved.

## 📚 Documentation

For complete information about Nginx Control and its features:

**Documentation:**
https://docs.nginx-control.rdr-it.com/

**Project website:**
https://nginx-control.rdr-it.com

## 🔗 Related projects

### Nginx Control

The dashboard used to manage and monitor this stack.

https://forge.rdr-it.com/Nginx/nginx-control

### Nginx Reverse Proxy image

The Nginx image used by this stack:

https://forge.rdr-it.com/Dockerfiles/nginx-reverse-proxy

## 🇫🇷 Français

# Stack Nginx Reverse Proxy

Ce dépôt contient les fichiers Docker Compose permettant de déployer un **reverse proxy Nginx avec Nginx Control**.

Le stack fournit une base complète pour déployer :

* Nginx
* Nginx Control
* Certificats SSL
* Let's Encrypt / Certbot
* GeoIP
* Logs Nginx
* Cache Nginx
* GoAccess
* Nginx Analyzer
* Sauvegardes locales
* Gestion de configuration avec Git

L'objectif est de disposer d'un **stack prêt à déployer**, tout en conservant une configuration Nginx classique et directement accessible sur le système de fichiers.

## 🌐 Projet

* **Site Nginx Control :** https://nginx-control.rdr-it.com
* **Documentation :** https://docs.nginx-control.rdr-it.com/
* **Code source Nginx Control :** https://forge.rdr-it.com/Nginx/nginx-control
* **Dépôt de déploiement :** https://forge.rdr-it.com/romain/Docker-Compose/src/branch/main/ReverseProxy

## 🏗️ Architecture

Le stack repose principalement sur deux conteneurs :

```text
                         Internet / LAN
                               │
                               ▼
                    ┌─────────────────────┐
                    │        Nginx        │
                    │   Reverse Proxy     │
                    │                     │
                    │  HTTP / HTTPS       │
                    │  VHosts             │
                    │  SSL               │
                    └──────────┬──────────┘
                               │
                    ┌──────────┴──────────┐
                    │                     │
                    ▼                     ▼
              Applications          Nginx Control
                                    Dashboard / API
                                         │
                 ┌───────────────────────┼──────────────────────┐
                 │                       │                      │
                 ▼                       ▼                      ▼
              Docker                  GitOps                GoAccess
              Socket                 Configuration           Analyzer
```

Nginx et Nginx Control sont connectés au réseau Docker `nginx-net`.

Nginx Control dispose également d'un accès au socket Docker afin de pouvoir effectuer les opérations liées au conteneur Nginx et aux fonctionnalités d'auto-configuration Docker.

## 📂 Arborescence

Les données du stack sont stockées à l'aide de bind mounts afin de rester directement accessibles sur l'hôte.

```text
ReverseProxy/
├── compose.yml
├── sample.env
├── nginx-dashboard.env
│
├── nginx/
│   ├── config/
│   │   ├── conf.d/
│   │   ├── sites/
│   │   ├── snippets/
│   │   └── streams/
│   ├── webroot/
│   ├── logs/
│   └── cache/
│
├── certificats/
│   ├── ssl/
│   └── certbot/
│
├── geoip_data/
│
├── config/
│   └── nginx-dashboard/
│       ├── config/
│       └── goaccess/
│
└── backups/
```

## 🚀 Déploiement

### Prérequis

Vous devez disposer de :

* Docker
* Docker Compose
* Un serveur Linux
* Des ports `80` et `443` disponibles

Créez le dossier de déploiement :

```bash
mkdir -p /containers/reverse-proxy
cd /containers/reverse-proxy
```

### Configuration

Copiez le fichier d'exemple :

```bash
cp sample.env .env
```

Puis adaptez les valeurs à votre environnement.

Les principaux paramètres sont :

```dotenv
RESTART_POLICY=always
NGINX_NETWORK=nginx-net

NGINX_TAG=1.30.5
NGINX_CONTAINER_NAME=nginx
NGINX_WORKER_PROCESSES=auto
NGINX_WORKER_CONNECTIONS=768

NGX_DHB_CONTAINER_NAME=nginx-dashboard
```

Les versions des images Nginx et Nginx Control peuvent être modifiées depuis le fichier `.env`.

## ▶️ Démarrer le stack

```bash
docker compose up -d
```

Vérifiez l'état des conteneurs :

```bash
docker compose ps
```

Pour consulter les logs :

```bash
docker compose logs -f
```

La configuration Nginx est automatiquement vérifiée au démarrage.

En cas d'erreur :

```bash
docker compose logs nginx
```

## ⚙️ Personnaliser le déploiement

Le fichier `compose.yml` doit rester autant que possible proche de la configuration du stack.

Pour vos personnalisations locales, utilisez :

```text
compose.override.yml
```

Par exemple :

```yaml
services:
  nginx-dashboard:
    ports:
      - "3000:3000"
```

Puis :

```bash
docker compose up -d
```

Docker Compose fusionnera automatiquement `compose.yml` et `compose.override.yml`.

Cela permet de personnaliser notamment :

* les ports ;
* les volumes ;
* les réseaux ;
* les variables d'environnement ;
* les limites de ressources ;
* les services supplémentaires.

## 🔐 Certificats SSL

Les certificats sont organisés dans :

```text
certificats/
├── ssl/
└── certbot/
```

Les certificats manuels sont disponibles dans Nginx sous :

```text
/ssl
```

Les données Certbot sont disponibles sous :

```text
/etc/letsencrypt
```

Cette organisation permet notamment de conserver une structure compatible avec les outils Nginx et Certbot classiques.

## 🧩 Configuration Nginx

La configuration est directement disponible sur l'hôte :

```text
nginx/config/
├── conf.d/
├── sites/
├── snippets/
└── streams/
```

Vous pouvez donc modifier les fichiers avec votre éditeur habituel, les gérer avec Git ou utiliser Nginx Control.

## 🐳 Réseau Docker

Le stack crée le réseau :

```text
nginx-net
```

Les applications devant être publiées par Nginx peuvent être connectées à ce réseau :

```yaml
services:
  web:
    image: nginx:alpine
    networks:
      - nginx-net

networks:
  nginx-net:
    external: true
```

Nginx peut alors communiquer directement avec le conteneur à travers son nom Docker.

Ce réseau est également utilisé par les fonctionnalités d'auto-configuration Docker de Nginx Control.

## 🤖 Auto-configuration Docker

Nginx Control permet de publier automatiquement les conteneurs Docker grâce aux labels.

Exemple :

```yaml
labels:
  - "nginx-control.enable=true"
  - "nginx-control.vhost.server_name=app.example.com"
  - "nginx-control.vhost.location01=/"
  - "nginx-control.vhost.location01.proxy_pass=http://web:80"
  - "nginx-control.network=nginx-net"
```

Nginx Control détecte alors le conteneur et peut générer automatiquement le Virtual Host Nginx correspondant.

La documentation Nginx Control détaille les labels disponibles ainsi que la publication de conteneurs sur des hôtes Docker distants.

## 📊 Supervision et logs

Les répertoires nécessaires aux fonctionnalités de supervision et d'analyse sont persistants :

```text
nginx/logs/
nginx/cache/
geoip_data/
config/nginx-dashboard/goaccess/
```

Ils sont utilisés notamment pour :

* les logs Nginx en temps réel ;
* Nginx Analyzer ;
* GoAccess ;
* l'analyse GeoIP ;
* la gestion du cache ;
* la supervision des backends.

## 💾 Sauvegardes

Les sauvegardes locales de configuration sont stockées dans :

```text
backups/
```

Elles sont accessibles depuis Nginx Control sous :

```text
/nginx/backups
```

Les sauvegardes restent donc disponibles indépendamment du cycle de vie du conteneur.

## 🔄 GitOps

Nginx Control peut utiliser un dépôt Git comme **source de vérité** pour la configuration Nginx.

Les répertoires suivants peuvent notamment être versionnés :

```text
nginx/config/conf.d/
nginx/config/sites/
nginx/config/snippets/
nginx/config/streams/
certificats/ssl/
```

Cela permet de conserver l'historique des modifications et de déployer une configuration validée depuis Nginx Control.

## 🔧 Mise à jour

Les versions des images peuvent être modifiées dans `.env`.

Par exemple :

```dotenv
NGINX_TAG=1.30.5
NGX_DHB_TAG=x.x.x
```

Puis :

```bash
docker compose pull
docker compose up -d
```

Les configurations et données présentes dans les répertoires montés restent conservées.

## 📚 Documentation

Pour découvrir toutes les fonctionnalités de Nginx Control :

**Documentation :**
https://docs.nginx-control.rdr-it.com/

**Site du projet :**
https://nginx-control.rdr-it.com

## 🔗 Projets associés

### Nginx Control

Dashboard permettant de gérer et superviser ce stack :

https://forge.rdr-it.com/Nginx/nginx-control

### Nginx Reverse Proxy

Image Nginx utilisée par ce stack :

https://forge.rdr-it.com/Dockerfiles/nginx-reverse-proxy
