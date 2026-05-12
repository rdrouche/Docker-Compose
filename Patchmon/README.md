# Patchmon

**Patchmon** est un outil de supervision dédié au suivi des correctifs et mises à jour des systèmes.  
Il permet de visualiser rapidement l’état de conformité des serveurs et postes,  
d’identifier les correctifs manquants ou en retard,  
et d’anticiper les risques de sécurité liés à l’absence de patchs.  
Patchmon facilite ainsi le pilotage et le reporting de la gestion des mises à jour.

## Déploiement

1\. Cloner le dossier Patchmon dans le dossier où vous souhaitez stocker le conteneur 

```
bash <(wget -qO- https://git.rdr-it.com/root/scripts/-/raw/master/Linux/rdr-it/get-docker-compse/get.sh) Patchmon

```

2\. Copier le fichier `sample.env` en le nommant `.env`

```
cp sample.env .env
```

3\. Editer le fichier .env 

1.  **POSTGRES\_PASSWORD** : changer le mot de passe Postgre
2.  **REDIS\_PASSWORD** : changer le mot de passe Redis
3.  **JWT\_SECRET** : générer un secret avec la commande suivante : `openssl rand -hex 64`
4.  **SERVER\_PROTOCOL** : protocole pour l'accès à la console et le connexion des agents (http / https)
5.  **SERVER\_HOST** : Nom DNS ou adresse IP qui permet l'accès à la console
6.  **SERVER\_PORT** : Port de publication si différent, changer également le port dans le service frontend