[![Docker Pulls](https://img.shields.io/docker/pulls/rdrit/nginx-rproxy?logo=docker&label=Docker%20Hub)](https://hub.docker.com/r/rdrit/nginx-rproxy)  ![Static Badge](https://img.shields.io/badge/Version-1.30.1-blue?logo=nginx&logoColor=green&logoSize=auto&link=https%3A%2F%2Fforge.rdr-it.com%2FDockerfiles%2F-%2Fpackages%2Fcontainer%2Fnginx-reverse-proxy%2F)
  [![Dockerfile](https://img.shields.io/badge/Dockerfile-View-blue?logo=docker)](https://forge.rdr-it.com/Dockerfiles/nginx-reverse-proxy)

# Nginx Reverse Proxy 

Ce dépôt contient une solution complète de Reverse Proxy Nginx optimisée, incluant la gestion automatique des certificats SSL (Cloudflare), la géolocalisation IP, et le filtrage avancé des bots.

Le dépot de construction de l'image : https://forge.rdr-it.com/Dockerfiles/nginx-reverse-proxy

## 🚀 Fonctionnalités

- Nginx RProxy : Serveur haute performance configuré pour le reverse proxy.
- Certbot & Cloudflare : Automatisation des certificats SSL Wildcard via DNS challenge.
- Géo-blocage (GeoIP2) : Restriction d'accès par pays via la base MaxMind.
- Sécurité des Bots : Listes blanches (Good Bots) et listes noires (Bad Bots, IA/Scrapers).
- Gestion d'Erreurs : Pages d'erreurs personnalisées et esthétiques qui utilise **[error-pages](https://github.com/tarampampam/error-pages)**.
- Cloudflare Ready : Restauration des IPs réelles des visiteurs derrière le proxy Cloudflare.
- Module Nginx VTS inclus - [nginx-module-vts](https://github.com/vozlt/nginx-module-vts)

## 📁 Structure du Projet

- conf/ : Fichiers de configuration Nginx globaux.
- snippets/ : Snippets réutilisables pour le filtrage (bots, pays, etc.).
- sites/ : Vos fichiers de configuration VirtualHost.
- certs/ : Certificats SSL générés par Certbot.
- geoip_data/ : Bases de données MaxMind (mises à jour automatiquement).

> Afin que les fichiers de configuration soit chargés par Nginx, ils doivent avoir l'extension `.conf`

## 🛠️ Installation

### 1. Prérequis

- Docker et Docker Compose.
- Un compte [Cloudflare](https://www.cloudflare.com/) (pour le DNS Challenge).
- Un compte [MaxMind](https://www.maxmind.com/) (pour les mises à jour GeoIP2).

### 2. Cloner le dossier

Créer un dossier : 

```
mkdir -p /containers/nginx-rproxy
cd /containers/nginx-rproxy
```

Cloner le dossier : 

```
bash <(wget -qO- https://forge.rdr-it.com/romain/Docker-Compose/raw/branch/main/get.sh) Nginx-RProxy
```

### 3. Configuration de l'environnement

Renommez sample.env en .env et ajustez les variables :

```
cp sample.env .env
nano .env
```

- Modifiez `CERTBOT_EMAIL` pour les notifications SSL.
- Renseignez vos identifiants `GEOIPUPDATE_ACCOUNT_ID` et `LICENSE_KEY`.

### 4. Configuration Cloudflare

Créez un dossier cloudflare et un fichier `credentials.ini` à l'intérieur :

```
dns_cloudflare_api_token = VOTRE_TOKEN_API_CLOUDFLARE
```

> Sécurisez le fichier : chmod 600 cloudflare/credentials.ini

### 5. Lancement

Démarrez les services Nginx et Error-Pages :

```
docker compose up -d
```
*Note : Pour inclure les services de mise à jour GeoIP et Certbot, utilisez les profils :*

```
docker-compose --profile all up -d
```

## 🛡️ Utilisation du filtrage

Le projet inclut des outils de filtrage pré-configurés dans le dossier `snippets/`.

### Blocage des bots (IA & Malveillants)

Dans vos fichiers de VirtualHost (`sites/*.conf`), vous pouvez bloquer les bots indésirables :

```
if ($bad_bot) { return 444; }
if ($ai_bot) { return 444; }
```

### Restriction par Pays (GeoIP2)

Deux politiques sont disponibles par défaut :

- `allow-visit-001.conf` : Autorise la France + Good Bots + IPs privées.
- `allow-visit-002.conf` : Autorise France, Irlande, Royaume-Uni + Good Bots + IPs privées.

> Pour fonctionner ces deux politiques ont besoins des fichiers suivants : `conf/private-ips.conf` et `conf/good-bots.conf`.

Exemple d'application :

```
if ($allow_visit_001 = 0) {
    return 403;
}
```
## 🔄 Mise à jour des bases GeoIP

Le service geoipupdate tourne en arrière-plan et vérifie les mises à jour de la base de données MaxMind toutes les 168 heures (hebdomadaire) par défaut.

## 📝 Personnalisation des certificats

Dans le fichier `docker-compose.yml`, modifiez la commande du service certbot pour inclure vos propres domaines :

```
-d votre-domaine.fr -d '*.votre-domaine.fr'
```

## Les variables d'environnement

### 🔧 NGINX

| Variable                   | Description                                                                                                               | Exemple  |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------- | -------- |
| `NGINX_TAG`                | Tag de l’image Docker Nginx utilisée. `latest` correspond à la dernière version disponible.                               | `latest` |
| `NGINX_RESTART_POLICY`     | Politique de redémarrage du conteneur Docker. `always` redémarre automatiquement le conteneur en cas d’arrêt ou de crash. | `always` |
| `NGINX_WORKER_PROCESSES`   | Nombre de processus workers Nginx. `auto` ajuste automatiquement selon le nombre de CPU disponibles.                      | `auto`   |
| `NGINX_WORKER_CONNECTIONS` | Nombre maximal de connexions simultanées par worker. Impacte les performances et la capacité de charge.                   | `768`    |

### 🚨 ERROR-PAGES

| Variable                     | Description                                               | Exemple      |
| ---------------------------- | --------------------------------------------------------- | ------------ |
| `ERROR_PAGES_TAG`            | Tag de l’image Docker des pages d’erreur.                 | `latest`     |
| `ERROR_PAGES_RESTART_POLICY` | Politique de redémarrage du conteneur des pages d’erreur. | `always`     |
| `ERROR_PAGES_TEMPLATE`       | Modèle de pages d’erreur utilisé (design / thème).        | `connection` |

### 🌍 GEOIPUPDATE

| Variable                     | Description                                                                                          | Exemple                          |
| ---------------------------- | ---------------------------------------------------------------------------------------------------- | -------------------------------- |
| `GEOIPUPDATE_TAG`            | Tag de l’image Docker utilisée pour GeoIP Update.                                                    | `latest`                         |
| `GEOIPUPDATE_RESTART_POLICY` | Politique de redémarrage du conteneur GeoIP Update.                                                  | `always`                         |
| `GEOIPUPDATE_ACCOUNT_ID`     | Identifiant de compte MaxMind requis pour télécharger les bases GeoLite.                             | `000000`                         |
| `GEOIPUPDATE_LICENSE_KEY`    | Clé de licence MaxMind associée au compte. **Doit rester confidentielle.**                           | `AbCdEfGh`                       |
| `GEOIPUPDATE_EDITION_IDS`    | Bases GeoIP téléchargées (ville, pays, etc.). Plusieurs valeurs possibles, séparées par des espaces. | `GeoLite2-City GeoLite2-Country` |
| `GEOIPUPDATE_FREQUENCY`      | Fréquence de mise à jour des bases GeoIP, en heures.                                                 | `168` (7 jours)                  |

### CERTBOT

| Variable                 | Description                                                                         | Exemple               |
| ------------------------ | ----------------------------------------------------------------------------------- | --------------------- |
| `CERTBOT_TAG`            | Tag de l’image Docker Certbot utilisée.                                             | `latest`              |
| `CERTBOT_RESTART_POLICY` | Politique de redémarrage du conteneur Certbot.                                      | `always`              |
| `CERTBOT_EMAIL`          | Adresse e-mail utilisée par Let’s Encrypt pour les alertes (expiration, problèmes). | `monemail@domain.tld` |


## Quelques commandes

Il est possible de modifier les fichiers de configuration et virtualhost sans avoir besoin de redémarrer le conteneur Nginx.

- Tester la configuration : `docker compose exec nginx nginx -t`
- Recharger la configuration : `docker compose exec nginx nginx -s reload`

## Chanlog

### 14/05/2026

- Passage version 1.30.x
- Registre par défaut pour l'image : https://forge.rdr-it.com/Dockerfiles/-/packages/container/nginx-reverse-proxy/

### 06/05/2026

- Nouvelle image basée sur l'image officiel nginx trixie
- Passage en version 1.29.8
- Arret du support du tag latest
- Ajout dans l'image du nginx du module VTS
- Suite au passage à Nginx 1.29.8, le snippet de logging a été modifié car nginx ne supporte plus les variables ($host) dans les chemins