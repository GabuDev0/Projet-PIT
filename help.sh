#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ./help.sh [{c}]

case $1 in
    "c")
        echo "Commandes disponibles: toutes les commandes bash. Scripts bash disponibles: ping.sh [ip_address] [key], connect.sh, decode.sh [file path] [key file path]"
        ;;
    0)
        echo ""
        ;;
    *)
        echo "Erreur: Argument inconnu"
        ;;
esac