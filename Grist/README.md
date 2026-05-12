## Présentation de Grist 

Grist est l'outil no-code de gestion de données de l'administration. Centralisez toutes les informations importantes concernant votre équipe au même endroit, et gérez le quotidien de ses membres (ex : gestion de congés ou calendrier de présence).

- Site : [www.getgrist.com/](https://www.getgrist.com/)
- Dépôt : [github.com/gristlabs/grist-core](https://github.com/gristlabs/grist-core)

## Déploiement de Grist

Créer un dossier pour cloner le dossier : 

``` bash
sudo mkdir -p /containers/grist
```

Se déplacer dans le dossier : 

``` bash
cd /containers/grist
```

Cloner le dossier avec la commande suivante : 

``` bash
bash <(wget -qO- https://git.rdr-it.com/root/scripts/-/raw/master/Linux/rdr-it/get-docker-compse/get.sh) Grist
```
## Configuration

Copier le fichier `sample.env` en le nommant `.env`

``` bash
sudo cp sample.env .env
```

Editer le fichier .env

``` bash
sudo nano .env
```
### Variables

La modification de certains paramètres pour changer la valeur par défaut nécessite de décommenter la lige de la variable dans le fichier `.env`.

### Paramètres commun

| Variable | Description | Valeur |
| --- | --- | --- |
| `VOLUME_PATH` | Emplacement relatif ou absolue des dossiers pour les volumeurs | `./` |
| `GRIST_TAG` | Tag de la version de l'image | `latest` |
| `GRIST_URL` | Url d'accès à l'application | `http(s)://grist.domain.tld` |
| `GRIST_DEFAULT_EMAIL` | Adresse e-mail pour les notifications | `grist@domain.tld` |
| `GRIST_FORCE_LOGIN` | Permet de forcer l'authentification des utilisateurs, nécessite la configuration d'un IdP. Décommenter le paramètre | Défaut : `false` - Passer à `true` pour forcer l'authentification|

### Base de données (PostgreSQL)

| Variable | Description | Valeur |
| --- | --- | --- |
| `POSTGRES_DB` | Nom de la base de données | Défaut : `grist` |
| `POSTGRES_USER`| Utilisateur de la base de données | Défaut : `grist` |
| `POSTGRES_PASSWORD` | Mot de passe pour accéder à la base de données | Défaut : `changeme` |

> [!CAUTION]
> Pour des raisons de sécurité, il est impératif de changer la valeur de la variable `POSTGRES_PASSWORD`.


### IdP OIDC

Avant de configurer l'IdP, déclarer l'application, les valeurs en exemple s'applique à [Authentik](https://rdr-it.com/deployer-authentik-docker-linux-guide-pas-a-pas/).

| Variable | Description | Valeur |
| --- | --- | --- |
| `GRIST_OIDC_IDP_ISSUER` |  | `https://authentik.domain.tld/application/o/<app-name>/` |
| `GRIST_OIDC_IDP_CLIENT_ID` |  | Client ID de l'IDP |
| `GRIST_OIDC_IDP_CLIENT_SECRET` |  | Secret du client de l'IDP |
| `GRIST_OIDC_IDP_SCOPES` |  | `openid profile email` |
| `GRIST_OIDC_SP_EXTRA_PROPS_TO_STORE` |   | `preferred_username` |
| `GRIST_OIDC_SP_IGNORE_EMAIL_VERIFIED` | Permet de désactiver la vérification e-mail au niveau de l'IDP | `true` |




