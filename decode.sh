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

# decode [file path] [key file path]
decode() {
    local _try_key=$(key_to_decimal $2)
    while read -r line; do
        # Récupère la valeur de chaque ligne et la trim (enlève les espaces)
        local _hex=$(echo "$line" | tr -d '[:space:]')
        
        # Convertit en décimal puis retire la clé
        local _decoded_decimal=$(( (0x$_hex - $_try_key) % 256))
        if (( _decoded_decimal < 0 )); then
            _decoded_decimal=$(( $_decoded_decimal + 256 ))
        fi

        # Reconvertit en hexa
        local _decoded_hex=$(printf "%02x" "$_decoded_decimal")                                               

        echo $_decoded_hex >> $TMP_FILE_NAME
    done < "$TXT_FILE_NAME"

    local _decoded=$(xxd -r -p < $TMP_FILE_NAME)

    printf %s "$_decoded"
    rm $TMP_FILE_NAME
}

TMP_FILE_NAME="tmp"
TXT_FILE_NAME=".secret"

echo "Message:"
decode "$1" $(< $2)