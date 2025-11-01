#!/usr/bin/env bash
set -e

MAX_WAIT=30   # temps max en secondes
INTERVAL=2    # intervalle entre les tests
ELAPSED=0

# Demarrage des conteneurs
sudo docker compose up -d --pull=missing

# Charger les variables depuis guacamole.env
if [ -f guacamole.env ]; then
    sudo export $(grep -v '^#' guacamole.env | xargs)
else
    echo "Erreur : fichier guacamole.env introuvable"
    exit 1
fi

echo "Attente que MariaDB soit pret..."

until sudo docker compose exec -T guacamole_db mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SELECT 1;" &>/dev/null; do
    if [ "$ELAPSED" -ge "$MAX_WAIT" ]; then
        echo "Timeout : MariaDB n a pas demarre dans ${MAX_WAIT} secondes."
        exit 1
    fi
    echo "MariaDB pas encore prete, attente ${INTERVAL} secondes..."
    sleep "$INTERVAL"
    ELAPSED=$((ELAPSED + INTERVAL))
done

echo "Initialisation de la base Guacamole..."

# Générer le script SQL d'initialisation
sudo docker compose run --rm guacamole /opt/guacamole/bin/initdb.sh --mysql > init-guacamole.sql

# Copier le script dans le conteneur MariaDB et l'exécuter
sudo docker compose exec -T guacamole_db mariadb --user=${MYSQL_USER} --password=${MYSQL_PASSWORD} ${MYSQL_DATABASE} < init-guacamole.sql

sudo docker compose down -v
sudo docker compose up -d

echo "Initialisation terminée ✅"