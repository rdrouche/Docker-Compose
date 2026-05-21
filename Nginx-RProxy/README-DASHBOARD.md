# Nginx Dashboard

Ce document vous explique comment configurer en parallèle du reverse proxy Nginx, le tableau de bord dédié à celui-ci.

## Principales fonctionnalités

Voici les principales fonctionnatité de Nginx Dashboard

- Statistiques des vitualhosts basés sur VTS
- Visualisation des fichiers de configuration
- Visualisation des certificats
- Affichage des fichiers de logs en directe (`tail -f`)
- Gestion de la configuration depuis Git
- Sauvegarde des fichiers des fichiers de configuration (Local + Git sur branche dédiée)
- Contrôle de Nginx (test de configuration + recharger)
- Générateur de virtualhost (d'enregistrement dans les fichiers de configuration Nginx)

Fonctionnalités optionnelles : 

- Intégration des **metrics** Crowdsec
- Génération de tableau de statiques de visite avec GoAccess par fichier de access log

## Prérequis

Conteneur Nginx Reverse Proxy en version 1.30.X ou plus récente.

> Depuis le passage à l'image Officiel, l'image Nginx Reverse Proxy intègre le module VTS

## Configuration basique

1. Modifier le mot de passe du compte admin et configurer son mot de passe, ouvrir le fichier : `nginx-dashboard/config/users.yml` modifier le `password` et passer enabled à `true`.
2. Editer les variables dans le fichier .env (https://forge.rdr-it.com/Dockerfiles/nginx-reverse-proxy-dashboard/wiki/Variables-d%27environnement-%E2%80%94-Nginx-Dashboard)

## Démarrer le conteneur

```bash
docker compose --profile dash up -d
```

ou

```bash
docker compose --profile all up -d
```

## Configuration avancées

### Crowdsec

Afin de pouvoir accéder au metric **Prometheus**, si Crowdsec fonctionne en conteneur, il faut déclarer le réseau

```yaml
...
services:
...
  nginx-dashboard:
    ..
    networks:
      - nginx-net
      - crowdsec-network
    ...

network:
  ...
  crowdsec-network:
    external: true
  ...
```

### GoAccess

Avant de lancer le premier conteneur GoAccess, il est nécessaire de télécharger l'image : 

```bash
docker pull allinurl/goaccess:latest
```
    
