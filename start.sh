#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ./start.sh

level=${1:--1}

case $level in
    -1)
        chmod +x activate_spy.sh
        chmod +x connect.sh
        chmod +x decode.sh
        chmod +x encode.sh
        chmod +x help.sh
        chmod +x ping.sh

        # // supprimer tous les fichiers inutiles

        rm -rf var/cache/tmp bin/

        mkdir -p var/cache/tmp bin/

        echo "Le jeu a commencé."
        echo

        echo $(< "mission.txt")
        echo

        echo "
        DÉBUT DU MESSAGE
        ** Vous avez réussi, ECHO s'est finalement montrée et le logiciel que vous aviez caché est maintenant opérationnel.

        Nous avons d'ores et déjà détecté une connexion 

        Si le plan se déroule sans encombre, les informations confidentielles sacrifiées ne seront rien en comparaison
        des informations que nous obtiendrions sur le mode de pensée d'ECHO.


        Lancez le script activate_spy.sh et découvrez 
        
        **
        FIN DU MESSAGE"

        echo "Relancez le script avec le paramètre 0 pour commencer le jeu."

        echo "Vous pouvez aussi relancer le script sans argument pour recommencer le jeu."
        ;;
    0)
        ./create_logs.sh
        ;;
esac





echo "Vous pouvez exécuter le script help.sh [c] pour la liste des scripts à utiliser ou, help.sh [num_jeu]
pour un indice dans le mini-jeu spécifié"

