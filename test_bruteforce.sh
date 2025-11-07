#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# En analysant les réponses des requêtes, le joueur découvre que le pattern de construction de la clé de chiffrement:
# xX0

UPPER_CASE=( {A..Z} )
LOWER_CASE=( {a..z} )
DIGITS=( {0..9} )

for l1 in "${LOWER_CASE[@]}"; do
    for U in "${UPPER_CASE[@]}"; do
        for d in "${DIGITS[@]}"; do
            combo="${l1}${U}${d}"
            printf 'Testing %s\n' "$combo"
            output=$(./decode.sh .secret "$combo" 2>/dev/null) || true
            # On teste la présence du flag "MESSAGE:" dans la sortie
            if printf '%s' "$output" | grep -q 'Message:'; then
                echo "FOUND: $combo"
                echo "Decoded output:"
                printf '%s\n' "$output"
                break 3   # sort des 3 boucles imbriquées
            fi
        done
    done
done

echo "Aucune combinaison trouvée"

exit 1