Cloner le depot dans le reptoire souhaité : 

```Bash
bash <(wget -qO- https://git.rdr-it.com/root/scripts/-/raw/master/Linux/rdr-it/get-docker-compse/get.sh) Gitlab
```

Editer le fichier gitlab.env pour configurer le compte root par défaut

Editer le fichier `gitlab-omnibus-config.rb` qui contient la configuration générale de Gitlab

Lancer le script de generation de configuration

```Bash
bash generate-gitlab-omnibus-env.sh
```

Télécharger l'image du conteneur : 

```Bash
docker compose pull
```

Démarrer le conteneur Gitlab : 

```Bash
docker compose up -d
```

Quelques commandes : 

Afficher le mot de passe par défaut du compte root sur la viriable est commentée : 

```Bash
sudo docker exec -it gitlab-gitlab-1 grep 'Password:' /etc/gitlab/initial_root_password
```

Vérifier la configuration ruby : 

```Bash
sudo docker exec -it gitlab-gitlab-1 sh -c 'echo "$GITLAB_OMNIBUS_CONFIG"'
```
