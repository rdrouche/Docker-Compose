# Changelog

## 20251211

### Added

docker-compose.yml - glpi-web : Suppression du HEALTHCHECK, celui-ci a ete integre a l image Docker

docker-compose.yml - glpi-cron : Desactivation du HEALTHCHECK lier a l image Docker

```
healthcheck:
  disable: true
```

Ajout d'une section scripts sur le depot, avec un premier qui permet la mise à jour du GLPI

Nouvelle variable d'environnement

*   `GLPI_HTTP_PROTOCOLE` : permet de configurer le protocole HTTP (**http**/https)
*   `GLPI_FORCE_APPLY_URI` : configure l'url GLPI au démarrage du conteneur (Yes/**No**)
*   `HEALTHCHECK_DISABLE` : permet de desactiver le HEALTHCHECK du conteneur glpi-web (Yes/**No**)