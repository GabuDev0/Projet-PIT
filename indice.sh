#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if (( $1 == 0 )); then
    echo "Indice: vous n'êtes pas obligés de tout retenir..."
fi