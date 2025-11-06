#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ./decode.sh [file] [key]

# ** CONST

TXT_FILE_NAME="$1"
TMP_FILE_NAME="try_solution.solu"


# NOTE: 
# Bonus : éviter le fichier temporaire

#Tu peux aussi éviter $TMP_FILE_NAME et faire directement :

#decoded=$(while read -r line; do
#    hex=$(echo "$line" | tr -d '[:space:]')
#    dec=$((0x$hex - 0x$_try_key))
#    printf "%02x" "$dec"
#done < "$1" | xxd -r -p)

echo "$decoded"

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
        local _decoded_hex=$(printf "%02x" "$_decoded_decimal")                                               

        echo $_decoded_hex >> $TMP_FILE_NAME
    done < "$1"

    local _decoded=$(xxd -r -p < $TMP_FILE_NAME)
    rm $TMP_FILE_NAME

    echo $_decoded
}

verify_key() {
    decoded=$(decode $TXT_FILE_NAME $1) # Décode le message en hex du fichier message_chiffre en utilisant la clé passée en $1
    key=$(decipher_key "$(< ./var/cache/key)")

    correct_code="$(decode $TXT_FILE_NAME $key)"
    if [[ "$decoded" == "$correct_code" ]]; then
        echo "Vous avez trouvé le bon message !"
        echo "Contenu du message:"
        echo
        echo $decoded

    else
        echo "C'est pas le bon message..."
    fi
}

key_to_decimal() {
    local _key=$1
    local _res=0
    for (( i=0; i<${#_key}; i++ )); do
        char="${_key:$i:1}"
        printf -v decimal "%d" "'$char"
        
        _res=$(( $_res + $decimal))
    done

    echo $_res
}

verify_key $(key_to_decimal "$2")