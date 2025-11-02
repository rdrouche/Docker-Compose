#!/bin/bash
# ============================================================
# Génère un fichier gitlab-omnibus.env à partir d'un fichier
# Omnibus lisible.
# Ignore les lignes commentées (#) et les lignes vides.
# ============================================================

CONFIG_FILE="gitlab-omnibus-config.rb"
OUTPUT_FILE="gitlab-omnibus.env"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "❌ Fichier $CONFIG_FILE introuvable."
  exit 1
fi

# Suppression di fichier existant
sudo rm -f ${OUTPUT_FILE}

# Lire le fichier, ignorer les lignes vides et commentées, concaténer avec des ";"
#CONFIG_VALUE=$(grep -v '^\s*#' "$CONFIG_FILE" | grep -v '^\s*$' | tr '\n' ';' | sed 's/;*$//')


# Générer le fichier .env
cat > "$OUTPUT_FILE" <<EOF
GITLAB_OMNIBUS_CONFIG="${CONFIG_VALUE}"
EOF

echo "✅ Fichier $OUTPUT_FILE généré avec succès."
echo "Contenu :"
cat "$OUTPUT_FILE"