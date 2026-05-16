# CodeLaunch

**CodeLaunch** est une plateforme web auto-hébergée qui permet de lancer des environnements [VS Code Server](https://github.com/coder/code-server) à la demande, via une interface web simple.

Elle remplace un workflow N8N + SSH par une API Node.js directement connectée au socket Docker.

---

## Sommaire

- [CodeLaunch](#codelaunch)
  - [Sommaire](#sommaire)
  - [Fonctionnalités](#fonctionnalités)
  - [Architecture](#architecture)
  - [Prérequis](#prérequis)
  - [Installation](#installation)
  - [Configuration](#configuration)
  - [Branding](#branding)
  - [Slugs et identifiants utilisateurs](#slugs-et-identifiants-utilisateurs)
    - [Génération](#génération)
    - [Avantages](#avantages)
    - [Changement d'email](#changement-demail)
    - [Collision](#collision)
  - [Interface Admin](#interface-admin)
  - [OIDC (futur)](#oidc-futur)
  - [API Reference](#api-reference)
    - [Publique](#publique)
    - [Admin (authentification session requise)](#admin-authentification-session-requise)
  - [Sécurité](#sécurité)

---

## Fonctionnalités

- **Interface utilisateur** : saisie d'un email → lancement du conteneur → envoi du mot de passe par email
- **URL directe** affichée dans l'interface (`https://codes.example.com/<slug>/`)
- **Interface admin** complète : tableau de bord, gestion conteneurs, utilisateurs, audit log
- **Limit de conteneurs** configurable (ex. 50 simultanés max)
- **Domaines autorisés** : restriction par domaine email
- **Slugs uniques** : hash SHA-256 de l'email (12 chars hex), stocké en BDD pour permettre la rotation
- **Données persistantes** : bind mount host vers `/code-server-data/<slug>/config`
- **Reverse proxy Traefik** : configuration automatique via labels Docker
- **Journal d'audit** : toutes les actions sont tracées
- **Branding configurable** : nom, couleurs, logo via variables d'environnement
- **Architecture OIDC-ready** : champ `oidc_sub` en BDD, bouton SSO préparé

---

## Architecture

```
┌────────────────────────────────────────────────┐
│                  Internet                      │
└──────────────────────┬─────────────────────────┘
                       │ HTTPS
               ┌───────▼────────┐
               │    Traefik     │  (reverse proxy existant)
               └───────┬────────┘
          ┌────────────┼────────────────┐
          │            │                │
   ┌──────▼──────┐     │         ┌──────▼──────────────┐
   │  CodeLaunch │     │         │  code-<slug>        │
   │  backend    │     │         │  (Code Server)      │
   │  Node.js    │     │         │  /slug/             │
   │  :3000      │     │         │  :8443              │
   └──────┬──────┘     │         └─────────────────────┘
          │ Docker API  │         (N conteneurs)
          ▼            │
   /var/run/docker.sock
```

- **`launch.example.com`** → Interface utilisateur + API + Admin
- **`codes.example.com/<slug>/`** → Conteneurs Code Server individuels
- Les deux domaines peuvent être identiques ou différents.

---

## Prérequis

- Docker + Docker Compose v2
- Traefik déjà configuré avec réseau `proxy` et entrée `websecure` (TLS)
- `msmtp` configuré sur le host (profil `default`) pour l'envoi d'emails
- Node.js 20+ (uniquement pour le développement local)

---

## Installation

```bash
# 1. Cloner le projet

mkdir -p /containers/codelaunch
cd /containers/codelaunch
bash <(wget -qO- https://forge.rdr-it.com/romain/Docker-Compose/raw/branch/main/get.sh) Code-Launch

# 2. Copier et configurer l'environnement
cp .env.example .env
nano .env

# 3. Launch
docker compose up -d
```

---

## Configuration

Toute la configuration se fait via le fichier `.env` :

| Variable | Défaut | Description |
|---|---|---|
| `APP_PORT` | `3000` | Port interne du backend |
| `BASE_URI` | — | Domaine des Code Servers (`codes.example.com`) |
| `BASE_UI_DOMAIN` | — | Domaine de l'interface CodeLaunch |
| `DOCKER_NETWORK` | `proxy` | Réseau Docker Traefik |
| `MAX_CONTAINERS` | `50` | Limite simultanée (0 = illimité) |
| `ALLOWED_DOMAINS` | vide | Domaines email autorisés, séparés par `,` |
| `CODE_SERVER_IMAGE` | `lscr.io/linuxserver/code-server` | Image Docker Code Server |
| `CODE_SERVER_DATA_PATH` | `/code-server-data` | Dossier host pour les données |
| `CODE_SERVER_PASSWD_PATH` | `/var/lib/code-server` | Dossier host pour les mots de passe |
| `BRAND_NAME` | `CodeLaunch` | Nom affiché |
| `BRAND_PRIMARY_COLOR` | `#2ea8ff` | Couleur principale |
| `BRAND_ACCENT_COLOR` | `#00e5c0` | Couleur accent |
| `BRAND_LOGO_URL` | vide | URL du logo (laissez vide pour emoji ⚡) |
| `ADMIN_USERNAME` | `admin` | Login admin |
| `ADMIN_PASSWORD` | — | Mot de passe admin **(à changer !)** |
| `MAIL_FROM` | — | Adresse expéditeur |
| `MAIL_CMD` | `msmtp` | Commande d'envoi email |
| `TZ` | `Europe/Paris` | Fuseau horaire des conteneurs |

---

## Branding

CodeLaunch est conçu pour être rebranded facilement :

```bash
# Dans .env :
BRAND_NAME=MonCloud
BRAND_PRIMARY_COLOR=#6c3bff
BRAND_ACCENT_COLOR=#ff6b35
BRAND_LOGO_URL=https://example.com/logo.png
```

Le frontend charge dynamiquement ces valeurs via `/api/config` au démarrage.

---

## Slugs et identifiants utilisateurs

Chaque utilisateur reçoit un **slug unique** qui sert d'identifiant dans l'URL :

```
https://codes.example.com/<slug>/
```

### Génération

Le slug est un **hash SHA-256 de l'email (12 premiers caractères hexadécimaux)** :

```
email: john.doe@example.com
hash:  SHA-256("john.doe@example.com")[:12] → "a3f7b2c91d4e"
URL:   https://codes.example.com/a3f7b2c91d4e/
```

### Avantages

- **Reproductible** : le même email donne toujours le même slug (migration possible sans BDD)
- **Opaque** : l'email n'est pas lisible dans l'URL
- **Stable** : le slug ne change pas si l'email change (la BDD gère la liaison)

### Changement d'email

Via l'interface admin (`Utilisateurs → ✏️ Email`), l'admin peut changer l'email d'un utilisateur. Le slug reste identique, les données sont conservées.

### Collision

En cas de collision (improbable), un slug aléatoire est généré (`crypto.randomBytes(6).hex`).

---

## Interface Admin

Accessible sur `https://launch.example.com/admin`

- **Dashboard** : stats globales + conteneurs actifs
- **Conteneurs** : historique, statuts Docker/BDD, arrêt, suppression de données
- **Utilisateurs** : liste, changement d'email
- **Journal d'audit** : 200 dernières actions (lancement, arrêt, admin, erreurs)
- **Configuration** : vue des paramètres actifs

---

## OIDC (futur)

L'architecture est préparée pour OpenID Connect :

1. **BDD** : champ `oidc_sub` dans la table `users` pour stocker le `sub` OIDC
2. **Frontend** : bouton "Se connecter avec SSO" visible si `OIDC_ENABLED=true`
3. **Variables** : `OIDC_ISSUER`, `OIDC_CLIENT_ID`, `OIDC_CLIENT_SECRET`, `OIDC_REDIRECT_URI`

Pour l'implémentation, ajouter la librairie `openid-client` et créer `routes/auth.js` :
- `GET /api/auth/oidc` → redirect vers l'IdP
- `GET /api/auth/callback` → échange du code, création/liaison utilisateur via `oidc_sub`


---

## API Reference

### Publique

| Méthode | Route | Description |
|---|---|---|
| `GET` | `/api/config` | Configuration branding |
| `POST` | `/api/launch` | Lancer un conteneur (`{ email }`) |
| `GET` | `/api/status/:slug` | Statut d'un conteneur |

### Admin (authentification session requise)

| Méthode | Route | Description |
|---|---|---|
| `POST` | `/api/admin/login` | Connexion admin |
| `POST` | `/api/admin/logout` | Déconnexion |
| `GET` | `/api/admin/stats` | Statistiques globales |
| `GET` | `/api/admin/containers` | Liste tous les conteneurs |
| `GET` | `/api/admin/containers/running` | Conteneurs actifs (Docker) |
| `POST` | `/api/admin/containers/:slug/stop` | Arrêter un conteneur |
| `POST` | `/api/admin/containers/:slug/remove` | Supprimer un conteneur |
| `GET` | `/api/admin/users` | Liste des utilisateurs |
| `PATCH` | `/api/admin/users/:slug/email` | Changer l'email |
| `GET` | `/api/admin/users/:slug/data-size` | Taille des données |
| `DELETE` | `/api/admin/users/:slug/data` | Supprimer données + conteneur |
| `GET` | `/api/admin/audit` | Journal d'audit |
| `GET` | `/api/admin/settings` | Configuration active |


---

## Sécurité

- Rate limiting : 3 lancements par IP toutes les 15 minutes
- Cookies de session HTTPOnly + Secure
- Helmet.js pour les headers HTTP
- Validation email côté serveur
- Restriction par domaine email
- Mots de passe Code Server générés aléatoirement (16 chars base64)
- **Changez `ADMIN_PASSWORD` et `ADMIN_SESSION_SECRET` avant de déployer en production**
