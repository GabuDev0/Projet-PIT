#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

key_to_decimal() {
    local _key=$1
    local _res=0
    for (( i=0; i<${#_key}; i++ )); do
        char="${_key:$i:1}"
        printf -v decimal "%d" "'$char"
        
        _res=$(( $_res + $decimal))
    done

    echo $(($_res % 256))
}

# encode [message] [key]
encode() {
    local message="$1"
    local key=$(key_to_decimal $2)
    printf "%s" "$message" > "$TMP_FILE_NAME"
    : > $TXT_FILE_NAME

    while read -r line; do
        # Récupère la valeur de chaque ligne et la trim (enlève les espaces)
        hex=$(echo "$line" | tr -d '[:space:]')
        
        # Convertit en décimal puis ajoute la clé
        decimal_plus_key=$(( (0x$hex + $key) % 256 ))

        # Reconvertit en hexa
        hex_plus_key=$(printf "%02x" "$decimal_plus_key")

        echo $hex_plus_key >> $TXT_FILE_NAME
    done < <(xxd -p -c 1 "$TMP_FILE_NAME")

    rm $TMP_FILE_NAME
}

TMP_FILE_NAME="tmp"
TXT_FILE_NAME=".secret"

encode "$1" $2
echo "encode" "$1" $2