# Reverse proxy Nginx avec interface Web

>Malgrès la version 12.X.X : Nginx Dashboard (Nginx C****) est en cours de developpement.
>La version stable arrive sous peu :)

## Presentation

**Nginx, sans compromis.**

Cette stack Docker propose un environnement Nginx prêt à l'emploi pour déployer et administrer un reverse proxy tout en conservant la philosophie et la configuration native de Nginx.

L'objectif du projet est simple : **faciliter l'exploitation de Nginx sans ajouter une nouvelle couche d'abstraction**.

Contrairement à certaines solutions de reverse proxy qui imposent leur propre syntaxe, leurs conventions ou leur manière de déclarer les services, cette stack utilise directement les fichiers de configuration Nginx.

Si vous savez configurer Nginx, vous savez déjà utiliser cette stack.

```text
nginx/config/
├── conf.d/
├── sites/
├── snippets/
└── streams/
```

Vos configurations Nginx existantes peuvent ainsi être réutilisées directement, avec seulement quelques adaptations si nécessaire.

Mais la stack ne se limite pas à fournir un conteneur Nginx. Elle ajoute autour du moteur un ensemble d'outils permettant de simplifier son administration au quotidien :

* tableau de bord et monitoring ;
* visualisation et gestion des configurations ;
* consultation des logs en temps réel ;
* gestion des certificats ;
* sauvegarde des configurations ;
* validation et rechargement de Nginx ;
* gestion du cache ;
* déploiement Git / GitOps ;
* intégration avec CrowdSec ;
* analyse avancée des logs ;
* intégration ModSecurity et Coraza ;
* statistiques GoAccess ;
* gestion DNS avec GoDNS ;
* génération de certificats Let's Encrypt.

L'approche est volontairement **modulaire** : le cœur de la stack reste un Nginx classique et les fonctionnalités supplémentaires peuvent être ajoutées en fonction des besoins.

### Le principe

**Nginx reste le moteur. La stack s'occupe du reste.**

Vous conservez la puissance et la flexibilité de Nginx, notamment l'utilisation de directives comme `map`, `limit_req`, `proxy_cache`, GeoIP ou encore les nombreuses possibilités offertes par les configurations natives.

L'objectif n'est donc pas de remplacer Nginx par une nouvelle solution, mais de fournir **un environnement complet autour de Nginx pour faciliter son déploiement, son administration, sa supervision et son intégration avec d'autres outils.**


## Concept d'utilisation de Nginx

L’objectif de cette stack, et plus particulièrement de la partie Nginx, a été de conserver une configuration aussi proche que possible d’une utilisation classique de Nginx.

L’idée est de ne pas imposer une nouvelle convention de configuration, comme peuvent le faire certaines solutions de reverse proxy « packagées », qui nécessitent d’apprendre une syntaxe ou une organisation spécifique.

Cette approche permet une adoption beaucoup plus simple : si vous disposez déjà de configurations Nginx, celles-ci devraient pouvoir fonctionner directement, ou ne nécessiter que quelques adaptations mineures pour être intégrées à la stack.

Elle permet également de continuer à exploiter facilement l’ensemble des fonctionnalités natives de Nginx, qui peuvent parfois être limitées ou moins accessibles avec certaines solutions de reverse proxy.

On peut notamment continuer à utiliser :

- le cache de fichiers ;
- le rate limiting avec les directives `limit_req` et `limit_conn` ;
- GeoIP ;
- les directives `map` pour créer des règles de configuration dynamiques ;
- et plus généralement les nombreuses directives disponibles nativement dans Nginx.

Le choix a donc été de ne pas chercher à masquer Nginx derrière une couche d’abstraction, mais au contraire de conserver toute sa souplesse tout en simplifiant son déploiement et son exploitation.

L’ensemble des fichiers de configuration Nginx se trouve dans le répertoire nginx/config.

La configuration est organisée en plusieurs répertoires afin de conserver une structure claire :

- conf.d : configurations générales de Nginx chargé dans le contexte `http { }`
- sites : configurations des différents sites et virtual hosts
- snippets : fragments de configuration réutilisables 
- streams : configurations pour les connexions TCP/UDP

Pour qu’un fichier soit automatiquement chargé dans la configuration Nginx, il doit impérativement avoir l’extension .conf.

Cette convention permet également de désactiver facilement une configuration sans avoir à supprimer le fichier. Il suffit de modifier son extension, par exemple :

```
site.conf
```

devient :

```
site.conf.DISABLE
```

Le fichier n’étant alors plus chargé par Nginx, la configuration peut être conservée pour être réactivée ultérieurement en lui redonnant simplement l’extension .conf.

## Les différentes images de Nginx

Pour configurer votre reverse proxy, trois images Docker sont disponibles, selon les fonctionnalités dont vous avez besoin :

- Nginx standard : basée sur la version stable de Nginx (1.30.4) ;
- Nginx avec ModSecurity : permet d’ajouter des fonctionnalités WAF à Nginx (1.30.4-waf) ;
- Nginx avec Coraza : intègre le WAF nouvelle génération Coraza (1.30.4-coraza). Cette version est actuellement considérée comme expérimentale.

Le fonctionnement et la configuration de Nginx restent identiques quelle que soit l’image utilisée. Le choix de l’image permet simplement d'activer ou non les fonctionnalités WAF dont vous avez besoin.

Pour une utilisation classique en reverse proxy, l’image Nginx standard est donc suffisante. Si vous souhaitez ajouter une couche de protection WAF, vous pouvez utiliser la version ModSecurity ou expérimenter Coraza.

## Prérequis

Un serveur Linux avec Docker et Docker compose d'installé

> La documentation a été faite depuis un serveur Debian 13

## Installation et démarrage rapide

1. Sur le serveur créer un dossier qui va contenir le fichiers et dossiers du stack.

```bash
mkdir -p /containers/nginx
cd /containers/nginx
```

2. Cloner les fichiers disponibles sur le [dépôt](https://forge.rdr-it.com/romain/Docker-Compose/src/branch/main/ReverseProxy) :

```bash
bash <(wget -qO- https://forge.rdr-it.com/romain/Docker-Compose/raw/branch/main/get.sh) ReverseProxy
```

3. Copier le fichier `sample.env` en nommant `.env`

```bash
cp sample.env .env
```

4. Editer le fichier `.env` :

```bash
nano .env
```

5. Configurer le token et les secrets, un générateur est disponible [ici](https://tools.rdr-it.com/#randgen).

```ini
NGX_DHB_API_TOKEN=00abe4d1b52377ba70abd298ff8bc5454202a475f8fff80418cc78c61fd1135d
NGX_DHB_WEBHOOK_SECRET=c1f4446d99ae84ff76b3d925858709ff7cd3852e957bf389c3b0322ba6a66a68
NGX_DHB_SESSION_SECRET=9f25ba812bf03df536d1ef99bb287074dcf35380941b2b5bba81c97d409133c4
```

6. A partir de là, il est possible de démarrer les conteneurs pour avoir nginx

```bash
docker compose up -d
```

> Si les images ne sont pas présentes sur le serveur, elle seront automatiques télécharger lors du démarrage.

A partir de cette étape, le reverse proxy est opérationnel.

### Configurer l'accès au Tableau de bord

Par défaut, le tableau de bord n'est pas publié, vous avez deux solutions : 

- Publication par mappage de port au niveau Docker
- Créer un virtualhost dédié

Les identifiants par défaut sont : 
- Login : admin
- Mot de passe : changeme

### Changer le mot de passe par défaut

Avant de configurer l'accès, je vous conseille de changer le mot de passe par défaut.

Ouvrir le fichier **users.yaml** qui se trouve : `./config/nginx-dashboard/config/`

> Lors du démarrage du conteneur, celui-ci sera chiffré et donc plus en clair dans le fichier ***users.yaml***

```bash
nano config/nginx-dashboard/config/users.yml
```

Puis changer la valeur du paramètre `password:`.

### Publication par mappage port 

1. Créer un fichier override qui va permettre de modifier le stack de service sans toucher au `compose.yml`.

```bash
nano compose.override.yml
```

2. Ajouter le code suivant : 

```yaml
services:
  nginx-dashboard:
    ports:
      - "3000:3000"
```

3. Redémarrer les conteneurs :

```bash
docker compose up -d
```

> Cela devrait seulement recréer le conteneur du tableau de bord Nginx

### Créer un virtual host Nginx

Une autre solution est de créer un virtualhost et passer par Nginx pour accéder au tableau de bord.

> La configuration propose utilise volontaire http et non https à ce stade

1. Définir un enregistrement DNS et le faire pointer vers l'adresse IP du serveur.

2. Dans le dossier `./nginx/config/sites` créer un fichier `dashboard.conf`
 
> Il est impératif que l'extension du fichier soit .conf pour qu'il soit chargé par Nginx


3. Exemple de virtualhost

```nginx
server {
    listen 80;
    server_name nginx-dashboard.domain.tld;

    access_log /var/log/nginx/nginx-dashboard.domain.tld.access.log;
    error_log /var/log/nginx/nginx-dashboard.domain.tld.error.log;
    
    # Disable VTS on Dashboard
    vhost_traffic_status off;

    include snippets/remove-header.conf;

    set $backend http://nginx-dashboard:3000;
    resolver 127.0.0.11 valid=30s;

    location / {
        proxy_pass $backend;
        proxy_read_timeout 60s;
        include snippets/proxy-common.conf;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $http_connection;
    }
}
```

4. Tester la configuration de Nginx :

```bash
docker compose exec nginx nginx -t
```

> En cas d'erreur de configuration, corriger là.

5. Recharger la configuration :

```bash
docker compose exec nginx nginx -s reload
```

## Découverte et premier pas avec le Dashboard

Une fois connecté au Dashboard, vous arrivez sur une page de "monitoring" qui affiche des métriques fournie par le [module VTS](https://github.com/vozlt/nginx-module-vts) qui a été intégré à l'image Nginx.


La stack propose plusieurs fonctionnalités directement disponibles, **sans configuration supplémentaire**.

### Monitoring

* **Monitoring** : supervision de Nginx à l’aide de **VTS (Virtual Host Traffic Status)**.

### Configuration

La section **Configuration** regroupe les outils permettant de gérer et de consulter la configuration de Nginx :

* **Config files** : permet de visualiser les différents fichiers de configuration de Nginx ;
* **SSL Certificats** : affiche un aperçu des certificats présents dans les répertoires `certificats/ssl` et `certificats/certbots` ;
* **Live logs** : permet d'afficher en temps réel le contenu des fichiers de logs, de manière similaire à la commande `tail -f` ;
* **Sync fichiers ref** : permet de mettre à jour les fichiers de configuration fournis avec la stack ;
* **Générateur VHost** : éditeur en ligne permettant de générer une configuration de virtual host. La configuration générée n'est toutefois pas automatiquement enregistrée dans le répertoire `sites` ;
* **Backup** : permet de sauvegarder les fichiers de configuration de Nginx.

### Contrôle

La section **Contrôle** regroupe les différentes actions permettant d'administrer Nginx :

* **Contrôle de Nginx** : permet de tester la configuration Nginx, de recharger la configuration ou de redémarrer le conteneur ;
* **Cache Nginx** : affiche les métriques concernant le volume du cache et permet de le purger ;
* **Évènements** : affiche les logs générés par le tableau de bord.

## Les fonctionnalités supplémentaires facultative

Le tableau de bord Nginx peut également être enrichi à l’aide de configurations supplémentaires et s’interfacer avec différents services externes.

### Configuration

* **Déploiement Git** : permet de mettre en place une approche **GitOps** en utilisant un dépôt Git pour gérer les fichiers de configuration Nginx et leur sauvegarde. Les modifications peuvent ainsi être versionnées et déployées depuis le dépôt.

### Intégrations

Plusieurs intégrations sont également disponibles afin d’étendre les fonctionnalités du tableau de bord :

* **CrowdSec** : permet d’afficher les métriques CrowdSec via Prometheus et de bannir des adresses IP directement depuis l’interface à l’aide de l’API CrowdSec ;
* **Analyse** : s’appuie sur un conteneur supplémentaire, `nginx-analyzer`, pour analyser les logs Nginx et fournir des statistiques et des alertes supplémentaires ;
* **WAF** : permet de visualiser les logs générés par **ModSecurity** et **Coraza**. Cette fonctionnalité nécessite `nginx-analyzer` ;
* **Map** : permet de visualiser en temps réel la provenance du trafic. Cette fonctionnalité nécessite également `nginx-analyzer` ;
* **GoAccess** : fournit des statistiques sur le trafic web à partir des fichiers `access.log` de Nginx ;
* **GoDNS** : permet de gérer dynamiquement les enregistrements DNS ;
* **SSL / Certbot** : permet de générer des certificats **Let's Encrypt** à l’aide du challenge HTTP.

## Changelog

### 25/09/2026 - 12.16.0

- Modification general pour facilite le deploiement de **Nginx Control**
  - si mot de passe du compte admin est admin = generation aleatoire de celui-ci et visible dans les logs docker une fois
  - API_TOKEN et WEBHOOK_SECRET sont maintenant generer depuis l'interfacer web

Si les var d'ENV sont toujours présente, celle-ci prennet le dessus.

### 21/09/2026 - 12.5.0

Sortie de la version 12.5.0

- Nettoyage du fichier compose.yml, gestion des fonctionnalités supplémentaires depuis le Dashboard
- Passage de la configuration des fonctionnalités directement depuis le dashboard, cette solution permet une configuration depuis l'interface Web et l'activation de celle-ci sans avoir besoin de redémarrer le conteneur