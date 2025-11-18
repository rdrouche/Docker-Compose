Clone  le dossier du depot dans le repertoire souhaité : 

```console
bash <(wget -qO- https://git.rdr-it.com/root/scripts/-/raw/master/Linux/rdr-it/get-docker-compse/get.sh) Nexus3
```

Telecharger l image 

```console
docker compose pull
```
Demarrer le conteneur Nexus

```console
docker compose up -d
```