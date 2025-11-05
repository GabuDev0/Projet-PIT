#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'


case $1 in
    0)
        echo "Indice: il doit bien y avoir un moyen de sauvegarder tout ce texte..."
        ;;
    *)
        echo "Ce mini-jeu n'existe pas encore"
        ;;
esac