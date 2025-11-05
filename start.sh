#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

create_key() {
    local _key="BA100J"

    local _res=0
    for (( i=0; i<${#_key}; i++ )); do
        char="${_key:$i:1}"
        printf -v decimal "%d" "'$char"
        
        _res=$(( $_res + $decimal ** $i))
    done

    echo $_res
}

echo "$(basename "$0") a bien été lancé."

echo "Ceci est la phrase de fin à trouver :) hehehehe" > "solution.secret"

TXT_FILE_NAME="message_chiffre"

# Convertit la solution en hexa
xxd -p -c 1 "solution.secret" > $TXT_FILE_NAME

rm "solution.secret"

# Définit la clé tel que key dans [0, 9], et la met dans le fichier 
key=$(create_key)
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