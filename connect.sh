#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ./connect.sh



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

        str=$(random_str 5)

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
            random_strings
            echo

            progress_bar
            echo
            ;;
        1)
            random_strings
            random_sleep

            random_strings
            random_sleep

            random_strings
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
            echo "key: $(generate_encryption_key)"

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
            random_strings
            random_sleep
            ;;


    esac
}

random_strings() {
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

# chaine aléatoire de longueur $1
# random_str [int]
random_str() {
    CHARS=( {a..z} {A..Z} {0..9} )
    
    len=$1
    for ((i=0;i<len;i++)); do
        str+="${CHARS[RANDOM % ${#CHARS[@]}]}"
    done
    printf "%s" "$str"
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
    duration=0.$((($RANDOM % 20 + 10)))
    sleep $duration
}

generate_encryption_key() {
    UPPER_CASE=( {A..Z} )
    LOWER_CASE=( {a..z} )
    DIGITS=( {0..9} )

    # choisir indices aléatoires
    local idx0 idx1 idx2 idx3
    idx0=$(( RANDOM % ${#LOWER_CASE[@]} ))   # première minuscule
    idx1=$(( RANDOM % ${#UPPER_CASE[@]} ))   # majuscule
    idx2=$(( RANDOM % ${#DIGITS[@]} ))   # chiffre

    local key="${LOWER_CASE[idx0]}${UPPER_CASE[idx1]}${DIGITS[idx2]}"
    printf %s "$key"
}

WORDS=("auth" "access" "init" "ECHO" "recv" "send")
CHARS=( {a..z} {A..Z} {0..9} )
signals_seen=0
NBR_SIGNALS=5
EVIL_FILE_NAME=$(random_str 5).sh
ECHO_MSG="Message:
Voici notre prochain objectif: DÉTRUIRE LE DÉPARTEMENT TC

Voici les détails du plan:

XX XX X XXXX XX XX XX XXXX XXXXXXX XXX X X XXX XX X X X XX X X XXXXX XXX X
XXXXX X XX XX X XXXXX X XXXX X XXXXXXXXX X X XXXX X X XX X XXXXX X X XXXXX
XXXX X X XXXX X X XX X XXXX X X X XX XX X X XX X XXXXX X X XXXX X X XXX XX
XXXX X XX XX X XXXXXX X XX XX X XXXXX XXXXXX X XXX XXX X X X XX X X XX X X
X XXX X X XXXX X X XX X XXX XX X XX XX X XXXXX XXXXXX X XXXXXXXXX X X XXXX

XXX XXXXXX X XXXXXXXXX X X XXXX X X XX X X

Le fichier à envoyer est ./$EVIL_FILE_NAME"

IP=$(< "./var/cache/tmp/ip.solution")
AUTH_KEY=$(< "./var/cache/tmp/auth_key.solution")

# Vérif que l'ip / clé d'authentification sont les bonnes.
if [[ -f "./bin/key" && -f "./bin/ip" ]]; then
    if [[ "$(< "./bin/ip")" == "$IP" && "$(< "./bin/key")" == "$AUTH_KEY" ]]; then
        enc_key="$(generate_encryption_key)"
        echo $enc_key > "./var/cache/tmp/enc_key.solution"
        #./encode.sh "$ECHO_MSG" $enc_key
        ./encode.sh "$ECHO_MSG" "aA2"
        echo "$EVIL_FILE_NAME" > ./var/cache/tmp/evil_file.solution
        touch "$EVIL_FILE_NAME"
        fake_file_name=$(random_str 5).sh
        touch "$fake_file_name"
        
        clear
        while (( signals_seen < NBR_SIGNALS )); do
            random_noise
            ((signals_seen++))
            random_sleep
        done
    else
        echo "Error: wrong key/ip"
    fi
    
else
    echo "Error: key/ip not found in ./bin/"
fi