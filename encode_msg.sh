#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

decipher_key() {
    local _key=$1
    local _res=0
    for (( i=0; i<${#_key}; i++ )); do
        char="${_key:$i:1}"
        printf -v decimal "%d" "'$char"
        
        _res=$(( $_res + $decimal))
    done

    echo $_res
}

key=$(decipher_key "$(< ./var/cache/key)")

echo "Ceci est la phrase de fin à trouver :) hehehehe" > "solution.secret"

TXT_FILE_NAME=".secret"

# Convertit la solution en hexa
xxd -p -c 1 "solution.secret" > $TXT_FILE_NAME

rm "solution.secret"

# TODO: mettre dans une fonction encode()
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