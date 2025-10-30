#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

echo "$(basename "$0") a bien été lancé."

echo "Ceci est la phrase de fin à trouver :) hehehehe" > "solution.secret"

TXT_FILE_NAME="message_chiffre"

# Convertit la solution en hexa
xxd -p -c 1 "solution.secret" > $TXT_FILE_NAME

rm "solution.secret"

# Définit la clé tel que key dans [0, 9], et la met dans le fichier 
key=$((RANDOM % 10))
echo $key > key

while read -r line; do
    # Récupère la valeur de chaque ligne et la trim (enlève les espaces)
    hex=$(echo "$line" | tr -d '[:space:]')
    
    # Convertit en décimal puis ajoute la clé
    decimal_plus_key=$(( 0x$hex + $key ))

    # Reconvertit en hexa
    hex_plus_one=$(printf "%x" "$decimal_plus_key")
done < "$TXT_FILE_NAME"

echo "Le jeu a commencé."

# Temps au lancement du jeu
start_time=$(date +%s)