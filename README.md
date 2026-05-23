<!-- 20260523-01 -->
Dans ce depot retrouvé plusieurs application prete a etre deployer facilement avec Docker et Docker Compose.

## Comment utiliser ce dépôt

Commencer par créer un dossier sur votre serveur pour l'enregistrement des fichiers.

```Bash
sudo mkdir -p /containers/<app-name>
```

Ensuite aller dans le dossier :

```Bash
cd /containers/<app-name>

```

Entrer la ligne de commande pour récupérer les fichiers de l'application que vous souhaitez déployer

```Bash

bash <(wget -qO- https://forge.rdr-it.com/romain/Docker-Compose/raw/branch/main/get.sh) <app-name>

```

## Personnaliser le déploiement des stacks compose

Afin de garder "intacte" le fichier `docker-compose.yml` ou `compose.yml` du stack, utiliser la fonctionnalité override de Docker compose en créant un fichier `docker-compose.override.yml` ou `compose.override.yml` et en venant placer dedans vos configurations personnalisés sur le stack comme les volumes, port ...