# GLPI Agent Docker - RDR-IT 🚀

Un conteneur Docker pour déployer facilement l’**agent GLPI** et centraliser l’inventaire réseau de votre infrastructure.

Ce projet inclut une configuration prête à l’emploi et un support pour le plugin **Toolbox**, avec possibilité d’activer une authentification basique pour l’accès web.

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
    image: rdrit/glpi-agent:1.15
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
  -e GLPI_SERVER=https://helpme-noauth.bourges.fr \
  -e GLPI_SERVER_NO_SSL_CHECK=true \
  glpiagent
```


## 🔗 Documentation et tutoriels

Retrouvez le tutoriel complet pour configurer votre GLPI Agent Docker sur notre site :

👉 https://rdr-it.com

👉 https://rdr-it.com/glpi-11-configurer-inventaire-automatique-reseau-glpi-agent/

##💡 Notes

Le script entrypoint.sh initialise la configuration, vérifie les variables d’environnement et lance l’agent avec les paramètres adaptés.

L’authentification Toolbox n’est configurée que si l’utilisateur et le mot de passe sont définis.

L’interface web intégrée est activable via la variable GLPI_HTTPD.

## 🛠️ Contribution

Les contributions sont les bienvenues !
Pour toute suggestion ou bug, merci d’ouvrir un ticket dans le dépôt.