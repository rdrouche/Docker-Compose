Configuration Stack Apache Guacamole
====================================

Ce dépôt contient la configuration des variables d'environnement nécessaires au déploiement d'une instance **Apache Guacamole** s'appuyant sur une base de données **PostgreSQL** .

📋 Variables de Configuration
-----------------------------

Les variables sont réparties par composants pour faciliter la maintenance.

### ⚙️ Paramètres Communs

**Variable**

**Description**

**Valeur par défaut**

`RESTART_POLICY`

Politique de redémarrage des conteneurs Docker.

`always`

* * *

### 🐘 Base de données (PostgreSQL)

Configuration relative au stockage des données utilisateurs et des configurations de connexion.

**Variable**

**Description**

**Valeur par défaut**

`POSTGRESQL_HOSTNAME`

Nom d'hôte du service de base de données.

`guacamole-db`

`POSTGRESQL_DATABASE`

Nom de la base de données Guacamole.

`guacamole`

`POSTGRESQL_USERNAME`

Utilisateur de la base de données.

`guacamole`

`POSTGRESQL_PASSWORD`

Mot de passe de l'utilisateur.

`changeme`

`PGDATA`

Chemin de persistance des données PostgreSQL.

`/var/lib/postgresql/18/docker`

* * *

### 🌐 Interface Web (Guacamole Client)

Paramètres de l'application web et de l'intégration avec le tunnel `guacd` .

**Variable**

**Description**

**Valeur par défaut**

`GUACAMOLE_PORT`

Port d'écoute de l'interface web.

`8080`

`GUACD_HOSTNAME`

Nom d'hôte du service `guacd` .

`guacamole-guacd`

`REMOTE_IP_VALVE_ENABLED`

Active le support des headers Proxy (ex: Nginx/Traefik).

`true`

`POSTGRESQL_ENABLED`

Active l'authentification via PostgreSQL.

`true`

#### 🎥 Enregistrements (Session Recording)

**Variable**

**Description**

**Valeur par défaut**

`RECORDING_ENABLED`

Active l'enregistrement des sessions.

`true`

`RECORDING_SEARCH_PATH`

Chemin de stockage des enregistrements.

`/record`

* * *

### 🔐 Authentification OpenID (Optionnel)

Ces variables permettent d'activer le SSO via un fournisseur d'identité (IdP) externe.

> **Note :** Actuellement commentées dans la configuration de base.

*   `OPENID_AUTHORIZATION_ENDPOINT` : Point d'entrée de l'autorisation de l'IdP.
*   `OPENID_CLIENT_ID` : Identifiant client enregistré auprès de l'IdP.
*   `OPENID_REDIRECT_URI` : URL de redirection après authentification.
*   `EXTENSION_PRIORITY` : Définit l'ordre de priorité des méthodes de login (ex: `*,openid` ).

* * *

🚀 Utilisation Rapide
---------------------

1.  **Sécurité :** Modifiez impérativement le `POSTGRESQL_PASSWORD` avant le déploiement.
2.  **Persistance :** Assurez-vous que les dossiers définis dans `PGDATA` et `RECORDING_SEARCH_PATH` ont les droits d'écriture nécessaires sur l'hôte.
3.  **Déploiement :**
    
    Bash
    
    									
    										`docker-compose up -d`