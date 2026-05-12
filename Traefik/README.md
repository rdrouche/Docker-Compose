# Traefik – Reverse Proxy Docker

Ce projet permet de déployer **Traefik v3** comme **reverse proxy Docker** afin de publier des services web via les ports standards **HTTP (80)** et **HTTPS (443)**, en s’appuyant sur un **réseau Docker dédié (**`**proxy**`**)** et une configuration TLS dynamique.

* * *

## 📌 Prérequis

*   Docker ≥ 24.x
*   Docker Compose (plugin ou binaire)
*   Accès root ou sudo sur l’hôte
*   Ports **80**, **443** et **8080** ouverts sur le pare-feu
*   Réseau Docker externe `proxy`

* * *

## 🌐 Création du réseau Docker

Avant de démarrer Traefik, le réseau Docker **doit exister** :

`docker network create proxy`

Ce réseau est partagé entre Traefik et les conteneurs qu’il doit exposer.

* * *

## 📁 Arborescence recommandée

`. ├── docker-compose.yml ├── certs/ │   ├── wildcard.crt │   └── wildcard.key └── dynamic/    └── tls.yaml`

* * *

## 🔐 Gestion TLS

Traefik utilise une configuration **file provider** pour le TLS.

### Exemple de `dynamic/tls.yaml`

`tls:  certificates:    - certFile: /certs/wildcard.crt      keyFile: /certs/wildcard.key` 

➡️ Les certificats sont montés en **lecture seule** dans le conteneur.

* * *

## 🚀 Démarrage du service

`docker compose up -d`

Vérifier que le conteneur est bien lancé :

`docker ps`

* * *

## 📊 Dashboard Traefik

Le dashboard est activé en mode **insecure** (⚠️ à ne pas exposer publiquement sans protection).

*   URL :  
    👉 http://IP\_DU\_SERVEUR:8080

### ⚠️ Recommandation sécurité

En production, il est conseillé de :

*   Restreindre l’accès via firewall
*   Ajouter une authentification (basic auth / forward auth)
*   Publier le dashboard derrière Traefik lui-même

* * *

## ⚙️ Fonctionnement général

*   Traefik écoute sur :
    *   **80** → HTTP
    *   **443** → HTTPS
*   Les conteneurs Docker sont découverts automatiquement
*   Les services ne sont exposés **que s’ils ont des labels Traefik**
*   Le trafic est routé via le réseau Docker `proxy`

* * *

## 🧩 Exemple de service exposé via Traefik

``services:  whoami:    image: traefik/whoami    networks:      - proxy    labels:      - "traefik.enable=true"      - "traefik.http.routers.whoami.rule=Host(`whoami.example.com`)"      - "traefik.http.routers.whoami.entrypoints=websecure"      - "traefik.http.routers.whoami.tls=true" networks:  proxy:    external: true`` 

* * *

## 📝 Logs

*   Niveau de log Traefik : **DEBUG**
*   Access logs désactivés par défaut  
    (le chemin est néanmoins prêt : `/logs/access.log`)

➡️ Idéal pour les phases de debug ou d’intégration initiale.

* * *

## 🔒 Points de sécurité notables

*   `providers.docker.exposedByDefault=false`  
    → Aucun conteneur n’est exposé sans labels explicites
*   `serversTransport.insecureSkipVerify=true`  
    → Autorise le proxy vers des backends avec certificats auto-signés
*   Support des headers `X-Forwarded-*` pour intégration derrière un firewall ou load balancer

* * *

## 📦 Version Traefik

Par défaut :

`Traefik v3.6`

Possibilité de surcharger via variable d’environnement :

`export TRAEFIK_TAG=v3.6`

* * *

## ✅ Cas d’usage typiques

*   Mutualisation des ports 80/443
*   Suppression des ports non standards (10000, 10001…)
*   Simplification des règles firewall
*   Publication sécurisée de services Docker
*   Architecture prête pour entreprise / homelab avancé