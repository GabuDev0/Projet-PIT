#!/usr/bin/env bash

# Level 1:
# Cliquer sur une touche au hasard au signal
#
#

# Level 2:
# Écrire le bon chiffre
#
#

# Level 3:
# Recopier la phrase le plus vite possible
#
#

n=0 # Le niveau du mini-jeu
i=0 # le nbr d'itérations dans le mini-jeu
total_time=0 # le temps total d'un essai du mini-jeu

while [ $i -lt 5 ]; do
    sleep $((RANDOM % 3 + 1))
        echo -ne "\rGOOO\n"
        start_time=$(gdate +%s%3N)
        read -s -n1 touche
        end_time=$(gdate +%s%3N)
        time=$(( $end_time-$start_time ))

        total_time=$(($total_time + $time))

        echo
        echo Reaction time: "$time"ms

        ((i++))

        # ** Cheatcode **
        # Explication: lit le buffer du stdin caractère par caractère, mais celui-ci ne se reset pas à chaque itération.
        # Donc si on écrit pleins de caractères, tous les tests passeront avec ~10ms de moyenne.
done

echo Average time: $(($total_time/5))ms

if [[ $total_time/5 -le 300 ]]; then
    echo "Test réussi !"
    echo "Le morceau n°1 de la clé est: B"
else
    echo "Trop lent..."
fi