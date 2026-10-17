# Docker Compose — Applications prêtes à déployer

Une collection de configurations **Docker Compose prêtes à l'emploi** pour déployer facilement vos applications et services auto-hébergés.

Ce dépôt regroupe des stacks Docker organisées par application, avec différentes variantes de déploiement selon les besoins. L'objectif est de vous faire gagner du temps en vous proposant une base de configuration que vous pouvez utiliser directement ou personnaliser pour votre infrastructure.

🚀 **Vous souhaitez déployer une application sans repartir de zéro ?** Retrouvez les stacks disponibles et générez votre configuration personnalisée depuis RDR-IT.com.

- **Dépôt GitHub (mirroir) :** https://github.com/rdrouche/Docker-Compose
- ** Forgejo :** https://forge.rdr-it.com/romain/Docker-Compose/
- **Catalogue et générateurs de configuration :** https://rdr-it.com/docker-compose/

## Pourquoi utiliser ce dépôt ?

- **Déploiement simplifié :** récupérez les fichiers nécessaires à votre application sans avoir à parcourir l'ensemble du dépôt.
- **Plusieurs variantes disponibles :** choisissez la stack correspondant à votre environnement et à vos besoins.
- **Configurations personnalisables :** adaptez les ports, les volumes, les réseaux et les autres paramètres à votre infrastructure.
- **Générateurs de configuration :** utilisez les outils disponibles sur RDR-IT.com pour préparer une configuration adaptée à votre déploiement.
- **Évolutif :** les configurations sont regroupées par application afin de faciliter leur consultation et leur maintenance.

## Applications et stacks disponibles

Les applications sont organisées dans le dépôt par dossiers. Certaines disposent de plusieurs stacks correspondant à des architectures ou des modes de déploiement différents.

Par exemple, **Apache Guacamole** propose plusieurs variantes utilisant des moteurs de base de données différents, notamment MariaDB ou PostgreSQL.

Cette organisation permet de choisir directement la configuration adaptée à votre environnement, sans devoir modifier une stack existante pour changer complètement son architecture.

Consultez le dépôt pour découvrir les applications et les variantes disponibles :

https://github.com/rdrouche/Docker-Compose/tree/main

## Générateurs de configuration

Les générateurs disponibles sur RDR-IT.com vous permettent de préparer plus facilement le déploiement de certaines applications.

Ils complètent le dépôt en vous aidant à sélectionner et à personnaliser les paramètres nécessaires à votre installation.

**Catalogue Docker Compose :**

https://rdr-it.com/docker-compose/

**Exemple : générateur de configuration Apache Guacamole :**

https://rdr-it.com/docker-compose/#Guacamole

De nouveaux générateurs pourront être ajoutés progressivement pour les applications compatibles.

## Récupérer une stack

Pour récupérer les fichiers d'une application, créez d'abord un dossier sur votre serveur qui accueillera ses fichiers de configuration.

```bash
sudo mkdir -p /containers/<app-name>
cd /containers/<app-name>
```

Utilisez ensuite le script de récupération pour télécharger l'application souhaitée.

### Récupérer une application

```bash
bash <(wget -qO- https://forge.rdr-it.com/romain/Docker-Compose/raw/branch/main/get.sh) <app-name>
```

### Récupérer une stack spécifique

Si une application propose plusieurs variantes, vous pouvez sélectionner directement celle que vous souhaitez déployer.

```bash
bash <(wget -qO- https://forge.rdr-it.com/romain/Docker-Compose/raw/branch/main/get.sh) <app-name>/<stack-folder>
```

Remplacez `<app-name>` et `<stack-folder>` par les noms correspondant à l'application et à la stack choisies dans le dépôt.

> **Conseil :** avant d'exécuter un script téléchargé depuis Internet, prenez le temps de vérifier son contenu et sa provenance.

## Personnaliser une configuration

Les fichiers Compose fournis constituent une base de déploiement. Vous pouvez les adapter à votre environnement sans modifier directement la configuration d'origine.

Pour cela, privilégiez les fichiers d'override de Docker Compose :

- `compose.override.yml`
- `docker-compose.override.yml`

Selon le nom du fichier Compose principal fourni par la stack, créez le fichier d'override correspondant.

Vous pouvez notamment y définir vos propres :

- Ports publiés sur l'hôte ;
- Volumes et chemins de stockage ;
- Réseaux Docker ;
- Variables d'environnement ;
- Paramètres spécifiques à votre infrastructure.

Cette approche permet de conserver une configuration principale plus facile à mettre à jour, tout en séparant vos personnalisations.

Consultez la [documentation officielle de Docker Compose](https://docs.docker.com/compose/how-tos/multiple-compose-files/merge/) pour en savoir plus sur la fusion de plusieurs fichiers Compose.

## Bonnes pratiques

Avant de déployer une stack, prenez le temps de vérifier les éléments suivants :

- Les variables d'environnement et les paramètres à personnaliser ;
- Les mots de passe et les éventuels secrets ;
- Les ports exposés et les réseaux utilisés ;
- Les volumes et la persistance des données ;
- Les prérequis et les éventuelles dépendances de l'application.

Adaptez également la configuration à votre environnement avant toute utilisation en production.

## Contributions et améliorations

Ce dépôt évolue progressivement afin de proposer davantage d'applications, de variantes de déploiement et de configurations réutilisables.

Les retours, suggestions et contributions permettant d'améliorer les stacks existantes ou d'en ajouter de nouvelles sont les bienvenus.

Vous pouvez consulter le dépôt et y signaler les problèmes rencontrés :

https://github.com/rdrouche/Docker-Compose

---

**Gagnez du temps sur vos déploiements Docker !**

Parcourez le [catalogue Docker Compose de RDR-IT.com](https://rdr-it.com/docker-compose/), choisissez votre application et utilisez les générateurs disponibles pour préparer votre prochaine installation.