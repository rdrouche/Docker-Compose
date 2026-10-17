#!/bin/bash
set -euo pipefail
#set -euxo pipefail
export DEBIAN_FRONTEND=noninteractive

# VARIABLES A DEFINIR PAR UTILISATEUR
GLPI_VERSION_TARGET=11.0.8
GLPI_DOCKER_PATH=/containers/glpi
DO_BACKUP_DATABASE=Yes


# VARIABLES POUR LE SCRIPT
URL_DOWNLOAD_GLPI=https://github.com/glpi-project/glpi/releases/download/${GLPI_VERSION_TARGET}/glpi-${GLPI_VERSION_TARGET}.tgz
CURRENT_VERSION_FILE="$GLPI_DOCKER_PATH/data/glpi/src/autoload/constants.php"
ENV_FILE="$GLPI_DOCKER_PATH/.env"
REQUIRED_SERVICES=("glpi-web" "glpi-db")
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ERROR_VAR=false
DATE_DIR=$(date +"%Y%m%d-%H%M")
BACKUP_DB_DIR=$GLPI_DOCKER_PATH/backup/update/$DATE_DIR
BACKUP_GLPI_DIR=$GLPI_DOCKER_PATH/backup/update/$DATE_DIR/glpi

echo "Le script est situé dans : $SCRIPT_DIR"
echo ""
echo ""
echo "======================================================================"
echo "                           ⚠️  DISCLAIMER  ⚠️"
echo "----------------------------------------------------------------------"
echo "Ce script est fourni tel quel, sans aucune garantie."
echo "L'auteur du script ne pourra être tenu responsable en cas de perte de"
echo "données, panne système ou tout autre problème résultant de son usage."
echo
echo "Avant d'exécuter ce script, vous devez impérativement :"
echo "  - Vérifier que vous disposez d'une sauvegarde complète et fonctionnelle"
echo "    de votre instance GLPI (fichiers + base de données)."
echo "  - Vérifier que toutes les variables du script sont correctement"
echo "    définies et adaptées à votre environnement."
echo
echo "En continuant, vous acceptez l'entière responsabilité de son exécution."
echo "----------------------------------------------------------------------"
echo "Pour continuer, saisissez : [A]ccept"
echo "Toute autre réponse annulera immédiatement le script."
echo "======================================================================"
read -r -p "> " RESPONSE

if [[ "$RESPONSE" != "A" && "$RESPONSE" != "Accept" && "$RESPONSE" != "ACCEPT" ]]; then
    echo "❌ Action annulée. Aucune modification n'a été effectuée."
    exit 1
fi

echo ""
echo "✔ Accepté. Le script continue..."
echo ""

# Verification installation valide de GLPI
if [ ! -f "$CURRENT_VERSION_FILE" ]; then
    echo "❌ Erreur : fichier $CURRENT_VERSION_FILE introuvable"
    exit 2
fi

# Verification de la version de GLPI 
INSTALLED_VERSION=$(grep -oP "GLPI_VERSION', '\K\d+\.\d+\.\d+(-\w+)?" "$CURRENT_VERSION_FILE")
if [ -z "$INSTALLED_VERSION" ]; then
    echo "❌ Impossible de determiner la version installee"
    exit 3
fi

echo "[INFO] Version installee : $INSTALLED_VERSION"
echo "[INFO] Version cible : $GLPI_VERSION_TARGET"

INSTALLED_NUM=$(echo "$INSTALLED_VERSION" | awk -F. '{ printf("%d%03d%03d\n",$1,$2,$3); }')
LATEST_NUM=$(echo "$GLPI_VERSION_TARGET" | awk -F. '{ printf("%d%03d%03d\n",$1,$2,$3); }')

if [ "$INSTALLED_NUM" -gt "$LATEST_NUM" ]; then
    echo "✅  GLPI est deja a jour"
    exit 4  
fi

# CHARGEMENT DU FICHIER .env
if [ -f "${ENV_FILE}" ]; then
    set -a
    source ${ENV_FILE}
    set +a
else
    echo "❌ Fichier .env introuvable"
    exit 1
fi

#if [ "${GLPI_UPDATE_DB}" != "Yes" ]; then
#    echo "Dans le fichier .env, la variable GLPI_UPDATE_DB doit être configurer sur Yes pour mettre à jour la base de données au prochaine démarrage"
#    ERROR_VAR=true
#fi 

#if [ "${GLPI_DISABLE_MAINTENANCE}" != "Yes" ]; then
#    echo "Dans le fichier .env, la variable GLPI_DISABLE_MAINTENANCE doit être configurer sur Yes pour sortir GLPI du mode maintenance au prochaine démarrage"
#    ERROR_VAR=true
#fi

#if $ERROR_VAR; then
#  echo "⛔ Fin du script : configurer les variables puis relancer le script."
#  exit 1
#fi

# Creation du fichier /var/www/glpi/config/glpi_updating pour indiquer au conteneur qu une mise a jour doit etre
# appliquer sur la base de donnee et sortir du mode maintenance a la fin
touch "${GLPI_DOCKER_PATH}/data/glpi/config/glpi_updating"

# Verification conteneur en fonctionnement
cd "$GLPI_DOCKER_PATH" || { echo "❌ Répertoire introuvable : $GLPI_DOCKER_PATH"; exit 1; }

for srv in "${REQUIRED_SERVICES[@]}"; do
    if ! docker compose ps --services --filter "status=running" | grep -qw "$srv"; then
        echo "❌ Le service '$srv' n'est pas en cours d'exécution."
        exit 1
    else
        echo "✔ $srv est en fonctionnement."
    fi
done

# Creation dossier tmp pour le telechargement
echo "📂 Dossier tmp créé : $GLPI_DOCKER_PATH/tmp"
mkdir -p $GLPI_DOCKER_PATH/tmp
# Creation dossier backup
echo "📂 Dossier backup créé : $GLPI_DOCKER_PATH/backup"
mkdir -p $GLPI_DOCKER_PATH/backup
# Creation dossier backup/update
echo "📂 Dossier backup créé : $GLPI_DOCKER_PATH/update/backup"
mkdir -p $GLPI_DOCKER_PATH/backup/update
# Creation dossier pour la sauvegarde
echo "📂 Dossier de $DATE_DIR créé : $GLPI_DOCKER_PATH/backup/update/$DATE_DIR"
mkdir -p $GLPI_DOCKER_PATH/backup/update/$DATE_DIR
#mkdir -p $GLPI_DOCKER_PATH/backup/update/$DATE_DIR/glpi

if [ "${DO_BACKUP_DATABASE}" = "Yes" ]; then
    cd "$GLPI_DOCKER_PATH" || { echo "❌ Répertoire introuvable : $GLPI_DOCKER_PATH"; exit 1; }
    echo "💾 Dump de la base MariaDB..."
    docker compose exec -T glpi-db mariadb-dump -u"$GLPI_DB_USER" -p"$GLPI_DB_PASSWORD" "$GLPI_DB_NAME" > "$BACKUP_DB_DIR/glpi-db.sql"
    echo "✔ Dump terminé : $BACKUP_GLPI_DIR/glpi-db.sql"
fi

echo "Activation du mode maintenance"
cd "$GLPI_DOCKER_PATH" || { echo "❌ Répertoire introuvable : $GLPI_DOCKER_PATH"; exit 1; }
docker compose exec glpi-web php /var/www/glpi/bin/console glpi:maintenance:enable --allow-superuser

echo "Pause 10 secondes ..."

cd $GLPI_DOCKER_PATH/tmp
echo "Telechargement de GLPI ..."
wget $URL_DOWNLOAD_GLPI
echo "Decompression de l archive ..."
tar -xvzf glpi-${GLPI_VERSION_TARGET}.tgz

cd "$GLPI_DOCKER_PATH" || { echo "❌ Répertoire introuvable : $GLPI_DOCKER_PATH"; exit 1; }
echo "Arret des conteneurs pour sauvegardes des donners"
docker compose down -v 

echo "📦 Deplacent des fichiers GLPI dans ${BACKUP_GLPI_DIR} ..."
mv ${GLPI_DOCKER_PATH}/data/glpi ${BACKUP_GLPI_DIR}

echo "Creation du dossier GLPI ..."
mkdir -p ${GLPI_DOCKER_PATH}/data/glpi

echo "Deplacement des fichiers de la nouvelle de GLPI ..."
mv $GLPI_DOCKER_PATH/tmp/glpi/* ${GLPI_DOCKER_PATH}/data/glpi

echo "Restauration des fichiers (config, fichiers, plugins) ..."
cp -r ${BACKUP_GLPI_DIR}/files ${GLPI_DOCKER_PATH}/data/glpi
cp -r ${BACKUP_GLPI_DIR}/config ${GLPI_DOCKER_PATH}/data/glpi
cp -r ${BACKUP_GLPI_DIR}/marketplace ${GLPI_DOCKER_PATH}/data/glpi
cp -r ${BACKUP_GLPI_DIR}/plugins ${GLPI_DOCKER_PATH}/data/glpi

echo "Applications des droits du le dossier ${GLPI_DOCKER_PATH}/data/glpi"
chown www-data:www-data ${GLPI_DOCKER_PATH}/data/glpi -R

echo "Demarrage des conteneurs ..."
cd "$GLPI_DOCKER_PATH" || { echo "❌ Répertoire introuvable : $GLPI_DOCKER_PATH"; exit 1; }
docker compose up -d

echo "Pause de 30 secondes ..."
sleep 30

echo "Suppression du fichier : /var/www/glpi/config/glpi_updating"
rm -f "${GLPI_DOCKER_PATH}/data/glpi/config/glpi_updating"

echo "Suppression dossier tmp"
rm -r -f $GLPI_DOCKER_PATH/tmp

echo ""
echo ""
echo " ✔ Mise a jour terminee"
echo ""
echo "Verifier les logs des conteneurs avec la commande docker compose logs -f"
echo ""
echo "Verifier le bon fonctionnement de GLPI"
echo "Penser a supprimer le dossier de sauvegarde : "