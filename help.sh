#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ./help.sh [{c}]

case $1 in
    "c")
        echo "Commandes disponibles: toutes les commandes bash. Scripts bash disponibles: ping.sh [ip_address] [key], connect.sh"
        ;;
    *)
        echo "Erreur: Argument inconnu"
        ;;
esac