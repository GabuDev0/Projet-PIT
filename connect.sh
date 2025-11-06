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

random_line() {
    p=0

    while (( p < 100 )); do
        p=$(( p + RANDOM % 10 ))
        (( p > 100 )) && p=100

        str=$(random_string)

        printf "\rreading" "$str"
        random_sleep

    done
}

random_noise() {
    WORDS=("auth" "access" "init" "ECHO" "recv" "send")
    CHARS=( {a..z} {A..Z} {0..9} )

    # Choisir aléatoirement le type de texte
    type=$((RANDOM % 20))

    case $type in
        0)
            random_string

            progress_bar
            echo
            ;;
        1)
            random_string
            random_sleep

            random_string
            random_sleep

            random_string
            random_sleep

            echo
            ;;

        2)
            # chaine aléatoire avec adresse ip
            len=$((RANDOM % 15 + 5))
            log=$((RANDOM % 1000))
            word="${WORDS[RANDOM % ${#WORDS[@]}]}"
            str="$word"

            str+=" $((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
            random_echo "$str"

            random_sleep
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

            random_sleep
            ;;

        4)
            long_random_sleep
            ;;

        5)
            clear
            random_sleep
            ;;
        6)
            random_line
            ;;
        *)
            random_string
            random_sleep
            ;;


    esac
}

# TODO: faire que random_string renvoie juste une string normale, et on fait le random_echo et la boucle autre part. Jpp l'utiliser dans random_line
random_string() {
    WORDS=("auth" "access" "init" "ECHO" "recv" "send")
    CHARS=( {a..z} {A..Z} {0..9} )
    t=$((RANDOM % 10 + 2))
    # chaine aléatoire
    for ((i=0;i<t;i++)); do
        
        len=$((RANDOM % 15 + 5))
        log=$((RANDOM % 1000))
        word="${WORDS[RANDOM % ${#WORDS[@]}]}"
        str="$word"

        str+=" LOG: $log"
        for ((i=0;i<len;i++)); do
            str+="${CHARS[RANDOM % ${#CHARS[@]}]}"
        done
        random_echo "$str"
    done
}
random_echo() {
    if (( RANDOM % 2 == 0 )); then
        echo -ne "\r$1"
    else
        echo "$1"
    fi
}

random_sleep() {
    duration=0.0$(($RANDOM % 10))
    sleep $duration
}

long_random_sleep() {
    duration=0.$((($RANDOM % 20 + 10)*5))
    sleep $duration
}
clear

while (( signals_seen < NBR_SIGNALS )); do
    random_noise
    ((signals_seen++)) 
    random_sleep
done