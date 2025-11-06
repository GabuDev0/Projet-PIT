#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ./create_logs.sh

generate_random_ip() {
    printf "%d.%d.%d.%d" $((10 + RANDOM % 240)) $((1 + RANDOM % 253)) $((1 + RANDOM % 253)) $((1 + RANDOM % 253))
}

write_timeout() {
    local ip="$1"
    local seq="$2"
    local ts="$3"
    local msg
    msg=$(printf "%s echo net: SRC=192.1.1.x DST=%s ICMP_SEQ=%02d RESPONSE=timeout" \
            "$ts" "$ip" "$seq")

    echo "$msg"
    
    printf "%s\n" "$msg" >> "$NETLOG"
}

write_unreachable() {
    local ip="$1"
    local seq="$2"
    local ts="$3"
    local msg
    msg=$(printf "%s echo net: SRC=192.1.1.x DST=%s ICMP_SEQ=%02d RESPONSE=destination_unreachable" \
            "$ts" "$ip" "$seq")

    echo "$msg"
    
    printf "%s\n" "$msg" >> "$NETLOG"
}

write_ack_with_key() {
    local ip=$1
    local seq=$2
    local ts=$3
    local msg

    msg=$(printf "%s echo net: SRC=%s DST=192.1.1.x ICMP_SEQ=%02d RESPONSE=ACK keyfrag=%s SESSION=established" \
            "$ts" "$ip" "$seq" "$KEY")

    echo "$msg"
    
    printf "%s" "$ip" > "./var/cache/tmp/ip"
    printf "%s\n" "$msg" >> "$NETLOG"
}

write_ack_with_fake_key() {
    local ip=$1
    local seq=$2
    local ts=$3
    local fake_key=""
    local msg
    for ((i=0;i<5;i++)); do
        fake_key+="${CHARS[RANDOM % ${#CHARS[@]}]}"
    done

    msg=$(printf "%s echo net: SRC=%s DST=192.1.1.x ICMP_SEQ=%02d RESPONSE=ACK keyfrag=%s SESSION=established" \
            "$ts" "$ip" "$seq" "$fake_key")

    echo "$msg"
    
    printf "%s\n" "$msg" >> "$NETLOG"
}

write_ack() {
    local ip="$1"
    local seq="$2"
    local ts="$3"
    local msg

    msg=$(printf "%s echo net: SRC=%s DST=echo.dst ICMP_SEQ=%02d RESPONSE=ACK SESSION=established\n" \
            "$ts" "$ip" "$seq")

    echo "$msg"
  
    printf "%s\n" "$msg" >> "$NETLOG"
}

# ** CONST

OUTDIR="./var/log"
NETLOG="$OUTDIR/network.log"

: > "$NETLOG"

LEURRES=()
NUM_LEURRES=12
NBR_ENTRIES=10

TARGET_IP=$(generate_random_ip)

CHARS=( {a..z} {A..Z} {0..9} )

KEY=""

for ((i=0;i<5;i++)); do
    KEY+="${CHARS[RANDOM % ${#CHARS[@]}]}"
done
echo $KEY > "./var/cache/tmp/key"

while (( ${#LEURRES[@]} < NUM_LEURRES )); do
    ip=$(generate_random_ip)
    if [[ "$ip" != "$TARGET_IP" ]]; then
        LEURRES+=("$ip")
    fi
done

# /!\ si y'a un nombre d'essais limités pour ping, il faut que le nombre de FAKE KEY soit aussi fixe
for ((n=0;n<NBR_ENTRIES;n++)); do
    entry_type=$((RANDOM % 3))
    ts=$(date '+%Y-%m-%d %H:%M:%S')
    case $entry_type in
        0)
            # ACK
            ip_leurre=${LEURRES[$(( RANDOM % $NUM_LEURRES))]}
            write_ack "$ip_leurre" 1 "$ts"
            ;;
        1)
            # timeout
            ip_leurre=${LEURRES[$(( RANDOM % $NUM_LEURRES))]}
            write_timeout "$ip_leurre" 1 "$ts"
            ;;
        2)
            # unreachable
            ip_leurre=${LEURRES[$(( RANDOM % $NUM_LEURRES))]}
            write_unreachable "$ip_leurre" 1 "$ts"
            ;;
    esac
    if (( NBR_ENTRIES - n == 2)); then
        # real key
        write_ack_with_key "$TARGET_IP" 1 "$ts"
    fi
    if (( NBR_ENTRIES - n == 1)); then
        # fake key 
        ip_leurre=${LEURRES[$(( RANDOM % $NUM_LEURRES))]}
        write_ack_with_fake_key "$ip_leurre" 1 "$ts"
    fi

done