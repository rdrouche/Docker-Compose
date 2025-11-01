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
bash <(wget -qO- https://git.rdr-it.com/root/scripts/-/raw/master/Linux/rdr-it/get-docker-compse/get.sh) <app-name>

```