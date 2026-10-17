[![Docker Pulls](https://img.shields.io/docker/pulls/rdrit/glpi-agent?logo=docker&label=Docker%20Hub)](https://hub.docker.com/r/rdrit/glpi-agent) [![Docker Image Version](https://img.shields.io/docker/v/rdrit/glpi-agent/latest?logo=docker&label=version)](https://hub.docker.com/r/rdrit/glpi-agent) [![Docker Image Size](https://img.shields.io/docker/image-size/rdrit/glpi-agent/latest?logo=docker&label=image%20size)](https://hub.docker.com/r/rdrit/glpi-agent) [![Dockerfile](https://img.shields.io/badge/Dockerfile-View-blue?logo=docker)](https://forge.rdr-it.com/Dockerfiles/GLPI-Agent)

# GLPI Agent Docker - RDR-IT 🚀

Un conteneur Docker pour déployer facilement l’**agent GLPI** et centraliser l’inventaire réseau de votre infrastructure.

Ce projet inclut une configuration prête à l’emploi et un support pour le plugin **Toolbox**, avec possibilité d’activer une authentification basique pour l’accès web.

Images conteneur disponiblr sur : 

- https://forge.rdr-it.com/Dockerfiles/-/packages/container/glpi-agent/
- https://hub.docker.com/r/rdrit/glpi-agent

---

## 🔹 Fonctionnalités

- Déploiement rapide de GLPI Agent via Docker.
- Support complet du plugin **Toolbox**.
- Activation optionnelle d’un serveur web pour l’interface Toolbox.
- Authentification basique configurable pour l’interface Toolbox.
- Variables d’environnement pour personnaliser la configuration.
- Gestion SSL/HTTPS avec vérification ou désactivation du check SSL.
- Tagging dynamique des agents pour l’inventaire.

---

## 📦 Contenu du dépôt

- Exemple de `docker-compose.yml` pour lancer l’agent.
- Configurations de plugins (Toolbox, Auth) dynamiquement générées.

---

## ⚙️ Variables d’environnement

| Variable | Description | Par défaut |
|----------|-------------|------------|
| `GLPI_SERVER` | URL de votre serveur GLPI | `""` (obligatoire) |
| `GLPI_SERVER_SSL_FINGER_PRINT` | Empreinte SSL du serveur GLPI (optionnel) | `""` |
| `GLPI_SERVER_NO_SSL_CHECK` | Ignorer la vérification SSL (`true`/`false`) | `false` |
| `GLPI_TAG` | Tag pour l’agent | `docker-glpi-agent` |
| `GLPI_DEBUG` | Activer le mode debug (`true`/`false`) | `false` |
| `GLPI_HTTPD` | Activer le serveur web intégré (`true`/`false`) | `true` |
| `GLPI_HTTPD_PORT` | Port du serveur web intégré | `62354` |
| `GLPI_TOOLBOX_ENABLE` | Activer le plugin Toolbox (`true`/`false`) | `1` |
| `GLPI_TOOLBOX_AUTH_ENABLE` | Activer l’authentification du plugin Toolbox (`true`/`false`) | `false` |
| `GLPI_TOOLBOX_AUTH_USER` | Nom d’utilisateur pour l’authentification Toolbox | `""` |
| `GLPI_TOOLBOX_AUTH_PASSWORD` | Mot de passe pour l’authentification Toolbox | `""` |
| `GLPI_TOOLBOX_AUTH_PORT` | Port pour l’authentification Toolbox | `62354` |

> ⚠️ Les variables obligatoires doivent être définies sinon le conteneur ne démarrera pas.

---

## 🚀 Exemple avec Docker Compose

```yaml
services:
  glpi-agent:
    container_name: docker-glpi-agent
    image: forge.rdr-it.com/dockerfiles/glpi-agent
    ports:
      - 62354:62354
    volumes:
      - ./config/toolbox.yaml:/etc/glpi-agent/toolbox.yaml:rw
    environment:
      - GLPI_SERVER=https://glpi.domain.tld
      - GLPI_SERVER_NO_SSL_CHECK=true
```

## 📝 Lancement manuel


```console
docker run -d \
  --name docker-glpi-agent \
  -p 62354:62354 \
  -e GLPI_SERVER=https://glpi.domain.tld \
  -e GLPI_SERVER_NO_SSL_CHECK=true \
  forge.rdr-it.com/dockerfiles/glpi-agent
```

## 📦 Depuis le dépôt Git

Le dépôt se trouve à cette adresse : [git.rdr-it.com/root/docker-compose/-/tree/main/GLPI-Agent]([https://](https://git.rdr-it.com/root/docker-compose/-/tree/main/GLPI-Agent))

Sur votre serveur, aller dans le dossier où vous souhaitez mettre les fichiers du conteneur.

Cloner le dossier GLPI-Agent

```console
bash <(wget -qO- https://git.rdr-it.com/root/scripts/-/raw/master/Linux/rdr-it/get-docker-compse/get.sh) GLPI-Agent
```

Editer le fichier docker-compose.yml et adapter les variables.

Démarrer le conteneur GLPI-Agent

```console
docker compose up -d
```

Aller ensuite sur l'interface Web (http://ip-host-dicker:62354) de l'agent pour configurer la découverte réseau.

## 🔗 Documentation et tutoriels

Retrouvez le tutoriel complet pour configurer votre GLPI Agent Docker sur notre site :

👉 https://rdr-it.com

👉 https://rdr-it.com/glpi-11-configurer-inventaire-automatique-reseau-glpi-agent/

## 💡 Notes

Le script entrypoint.sh initialise la configuration, vérifie les variables d’environnement et lance l’agent avec les paramètres adaptés.

L’authentification Toolbox n’est configurée que si l’utilisateur et le mot de passe sont définis.

L’interface web intégrée est activable via la variable GLPI_HTTPD.

## 🛠️ Contribution

Les contributions sont les bienvenues !
Pour toute suggestion ou bug, merci d’ouvrir un ticket dans le dépôt.