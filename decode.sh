#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

TXT_FILE_NAME="message_chiffre"
TMP_FILE_NAME="try_solution.solu"

# decode [file] [key]
decode() {
    local _try_key=$2 # =chaine de caractères
    local _try_key_decimal=$((0x$_try_key))
    echo "" > $TMP_FILE_NAME
    while read -r line; do
        # Récupère la valeur de chaque ligne et la trim (enlève les espaces)
        local _hex=$(echo "$line" | tr -d '[:space:]')
        
        # Convertit en décimal puis retire la clé
        local _decoded_decimal=$(( 0x$_hex - $_try_key_decimal ))

        # Reconvertit en hexa
        local _decoded_hex=$(printf "%x" "$_decoded_decimal")                                               

        echo $_decoded_hex >> $TMP_FILE_NAME
    done < "$1"

    local _decoded=$(xxd -r -p < $TMP_FILE_NAME)
    rm $TMP_FILE_NAME

    echo $_decoded
}

verify_key() {
    decoded=$(decode $TXT_FILE_NAME $1) # Décode le message en hex du fichier message_chiffre en utilisant la clé passée en $1
    echo decoded: $decoded
    key=$(decipher_key "$(< ./var/cache/key)")

    correct_code="$(decode $TXT_FILE_NAME $key)"
    if [[ "$decoded" == "$correct_code" ]]; then
        echo "Vous avez trouvé le bon message !"
    else
        echo "C'est pas le bon message..."
    fi
}

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

verify_key $(decipher_key "$1")