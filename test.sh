#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

NBR_SIGNALS=100
signals_seen=0

progress_bar() {
    p=0

    while (( p < 100 )); do
        p=$(( p + RANDOM % 10 ))
        (( p > 100 )) && p=100

        # affiche la barre
        width=30
        filled=$(( p * width / 100 ))
        empty=$(( width - filled ))

        bar=""
        for ((i=0;i<filled;i++)); do bar+="#"; done
        for ((i=0;i<empty;i++)); do bar+="."; done

        printf "\rProgress: [%s] %d%%" "$bar" "$p"
        random_sleep
    done
}

random_noise() {
    random_sleep
    # Listes de fragments et mots
    WORDS=("auth" "access" "init" "ECHO" "recv" "send")
    CHARS=( {a..z} {A..Z} {0..9} )

    # Choisir aléatoirement le type de texte
    type=$((RANDOM % 7))

    case $type in
        0)
            # chaine aléatoire
            len=$((RANDOM % 15 + 5))
            log=$((RANDOM % 1000))
            word="${WORDS[RANDOM % ${#WORDS[@]}]}"
            str="$word"

            str+=" LOG: $log"
            for ((i=0;i<len;i++)); do
                str+="${CHARS[RANDOM % ${#CHARS[@]}]}"
            done
            random_echo "$str"
            
            # progress bar
            progress_bar
            echo
            ;;
        1)
            # chaine aléatoire
            len=$((RANDOM % 15 + 5))
            log=$((RANDOM % 1000))
            word="${WORDS[RANDOM % ${#WORDS[@]}]}"
            str="$word"

            str+=" LOG: $log"
            for ((i=0;i<len;i++)); do
                str+="${CHARS[RANDOM % ${#CHARS[@]}]}"
            done
            random_echo "$str"
            ;;

        2)
            # chaine aléatoire avec adresse ip
            len=$((RANDOM % 15 + 5))
            log=$((RANDOM % 1000))
            word="${WORDS[RANDOM % ${#WORDS[@]}]}"
            str="$word"

            str+=" $((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
            random_echo "$str"
            ;;

        3)
            # key
            len=$((RANDOM % 10 + 2))
            key=$(printf "%04d" $((RANDOM % 10000)))

            str="key: "
            for ((i=0;i<len;i++)); do
                key+="${CHARS[RANDOM % ${#CHARS[@]}]}"
            done
            str+=$key
            printf $key >> ./var/cache/key 
            random_echo "$str"
            ;;
            
    esac
}

random_echo() {
    if (( RANDOM % 3 == 0 )); then
        echo -ne "\r$1"
    else
        echo "$1"
    fi
}

random_sleep() {
    duration=0.0$((RANDOM % 10))
    sleep $duration
}

while (( signals_seen < NBR_SIGNALS )); do
    random_noise
    ((signals_seen++)) 
    random_sleep
done