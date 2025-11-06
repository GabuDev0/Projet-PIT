#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ./ping.sh [ip_address] [key]

target_ip="$1"
try_key="$2"
CORRECT_IP="$(< "./var/cache/tmp/ip")"
KEY="$(< "./var/cache/tmp/key")"

response_authorized() {
    local ip="$1"
    local seq=1
    local time=$((10+RANDOM%3)).$((RANDOM%1000))
    local msg

    msg=$(printf "64 bytes from %s icmp_seq=%02d ttl=114 time=%s ms" \
            "$ip" "$seq" "$time")

    echo "$msg"
}

response_unauthorized() {
    local src="$1"
    local dst="$2"
    local rule="${3:-999}" # $3 si spécifié, sinon 999
    local policy="${4:-blacklist}" # $4 si spécifié, sinon "blacklist"
    local ts
    ts=$(date '+%b %d %H:%M:%S')
    local msg
    msg=$(printf "[%s] kernel: fw: DROP SRC=%s DST=%s PROTO=ICMP POLICY=%s rule=%s REASON=administratively_prohibited" \
            "$ts" "$src" "$dst" "$policy" "$rule")
    echo "$msg"
}

response_unknown() {
    local ip="$1"
    local seq=1
    local time=$((10+RANDOM%3)).$((RANDOM%1000))
    local msg

    msg=$(printf "ping: cannot resolve %s: Unknown host" \
            "$ip")

    echo "$msg"
}

while true; do
    if [[ "$target_ip" == "$CORRECT_IP" ]]; then
        if [[ "$try_key" == "$KEY" ]]; then
            response_authorized $target_ip

        else
            response_unauthorized "192.1.1.x" "$target_ip" 102 "blacklist"
            break
        fi
    else
        response_unknown $target_ip
    fi

    sleep 1

done