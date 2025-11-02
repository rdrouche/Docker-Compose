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

CONFIG_SINGLELINE=""
BLOCK_LEVEL=0  # compteur pour suivre les blocs { et [

while IFS= read -r line; do
    # Supprimer commentaires et lignes vides
    [[ "$line" =~ ^\s*# ]] && continue
    [[ "$line" =~ ^\s*$ ]] && continue

    # Compter { et }, [ et ] pour savoir si on est dans un bloc
    OPEN_BRACES=$(echo "$line" | grep -o '{' | wc -l)
    CLOSE_BRACES=$(echo "$line" | grep -o '}' | wc -l)
    OPEN_BRACKETS=$(echo "$line" | grep -o '\[' | wc -l)
    CLOSE_BRACKETS=$(echo "$line" | grep -o '\]' | wc -l)

    BLOCK_LEVEL=$((BLOCK_LEVEL + OPEN_BRACES + OPEN_BRACKETS - CLOSE_BRACES - CLOSE_BRACKETS))

    # Supprimer espaces d  but/fin
    line=$(echo "$line" | sed 's/^[ \t]*//;s/[ \t]*$//')

    # Ajouter au r  sultat
    if [ $BLOCK_LEVEL -gt 0 ]; then
        #  ^` l'int  rieur d'un bloc, pas de ;
        CONFIG_SINGLELINE+="$line "
    else
        # Hors bloc, ajouter ;
        CONFIG_SINGLELINE+="$line; "
    fi
done < "$CONFIG_FILE"

# Nettoyer espaces multiples et dernier ;
CONFIG_SINGLELINE=$(echo "$CONFIG_SINGLELINE" | sed 's/  */ /g' | sed 's/; $//')

# Générer le fichier .env
#cat > "$OUTPUT_FILE" <<EOF
#GITLAB_OMNIBUS_CONFIG="${CONFIG_VALUE}"
#EOF
# Générer le fichier .env
cat > "$OUTPUT_FILE" <<EOF
GITLAB_OMNIBUS_CONFIG="${CONFIG_SINGLELINE}"
EOF

echo "✅ Fichier $OUTPUT_FILE généré avec succès."
echo "Contenu :"
cat "$OUTPUT_FILE"