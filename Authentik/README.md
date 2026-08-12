## Authentik

Fichier compose.yml basé sur : [goauthentik.io/docker-compose.yml](https://goauthentik.io/docker-compose.yml)

1. Cloner le dossier dans un dossier dedie sur votre serveur : 

```bash
bash <(wget -qO- https://forge.rdr-it.com/romain/Docker-Compose/raw/branch/main/get.sh) Authentik

```

2. Generer les differents secrets : 

```bash
# Mot de passe postgre
echo "PG_PASS=$(openssl rand -base64 36 | tr -d '\n')" > .env
# Secret Authentik
echo "AUTHENTIK_SECRET_KEY=$(openssl rand -base64 60 | tr -d '\n')" >> .env
```

3. Editer le fichier .env et adapter avec les variables ci-dessous (optionnel)

```bash
sudo nano .env
```

Variables :

```

```

4. Demarrer le conteneur

```bash
sudo docker compose up -d
```

5. Aller ensuite sur la page d'initialisation

http://<ip>:9000/if/flow/initial-setup/