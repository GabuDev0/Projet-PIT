#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ./help.sh [{c}]

case $1 in
    "c")
        echo "Commandes disponibles: toutes les commandes bash. Scripts bash disponibles: ping.sh [ip_address] [key], connect.sh, decode.sh [file path] [key file path]"
        ;;
    0)
        echo "Regardez les logs du réseau. Il doit forcément y avoir une bonne combinaison IP/clé. Quand vous les aurez trouvés, mettez les dans le dossier ./bin/, puis lancez le script connect.sh"
        ;;
    1)
        echo "Il doit bien y avoir un indice sur la forme de la clé de chiffrement quelque part..."
        ;;
    *)
        echo "Erreur: Argument inconnu"
        ;;
esac