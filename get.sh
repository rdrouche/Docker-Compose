#!/bin/bash
# ============================================================
# fetch_one.sh - Récupère un dossier spécifique d'un dépôt Git
# Usage :
#   bash <(wget -qO- https://git.rdr-it.com/root/tools/raw/main/fetch_one.sh) <dossier> [--nomove]
#
# Exemple :
#   bash <(wget -qO- https://git.rdr-it.com/root/tools/raw/main/fetch_one.sh) Bunkerweb
# ============================================================

set -e

REPO_URL="https://forge.rdr-it.com/romain/Docker-Compose.git"
TARGET_DIR="$1"
MOVE_FILES=true
TMP_DIR=/tmp/${TARGET_DIR}
START_DIR="$(pwd)"  # Capture du répertoire d'appel

# Vérifications de base
if [ -z "$TARGET_DIR" ]; then
  echo "❌ Erreur : aucun dossier spécifié."
  echo "Usage : $0 <dossier> [--nomove]"
  exit 1
fi

if [ "$2" == "--nomove" ]; then
  MOVE_FILES=false
fi

# Vérifier que git est installé
if ! command -v git &>/dev/null; then
  echo "❌ Git n'est pas installé. Installez-le avant d'exécuter ce script."
  exit 1
fi

echo "📦 Clonage sélectif du dossier '$TARGET_DIR' depuis le dépôt..."
echo "🕓 Dépôt : $REPO_URL"

sudo mkdir -p "${TMP_DIR}"
cd "$TMP_DIR"

# Clonage léger sans checkout
sudo git clone --filter=blob:none --no-checkout -b main "$REPO_URL" repo &>/dev/null
cd repo

# Initialisation du mode sparse-checkout
sudo git sparse-checkout init --cone
sudo git sparse-checkout set "$TARGET_DIR"

# Checkout du contenu
sudo git checkout main &>/dev/null

# Vérification de l'existence du dossier
if [ ! -d "$TARGET_DIR" ]; then
  echo "❌ Le dossier '$TARGET_DIR' n'existe pas dans le dépôt."
  exit 1
fi

if [ "$MOVE_FILES" = true ]; then
  echo "📂 Déplacement du contenu dans le dossier courant (${START_DIR})..."
  shopt -s dotglob
  sudo mv "$TARGET_DIR"/* "$START_DIR"/
  shopt -u dotglob
  echo "🧹 Nettoyage..."
  cd "$START_DIR"
  sudo rm -rf "$TMP_DIR"
else
  echo "📁 Le dossier récupéré est disponible dans : $TMP_DIR/repo/$TARGET_DIR"
  echo "ℹ️ Option --nomove utilisée, rien n’a été déplacé."
fi

echo "✅ Dossier '$TARGET_DIR' récupéré avec succès !"
