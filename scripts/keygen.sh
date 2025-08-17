#!/usr/bin/env bash
set -euo pipefail

# Allowed characters: letters, digits, dash, underscore
VALID_REGEX='^[A-Za-z0-9_-]+$'

# --- Helper functions ---
ask_input() {
    local varname="$1"
    local prompt="$2"
    local value=""
    while true; do
        read -rp "$prompt: " value
        if [[ -n "$value" && "$value" =~ $VALID_REGEX ]]; then
            printf -v "$varname" '%s' "$value"
            break
        else
            echo "Invalid input. Use only letters, numbers, dash (-) or underscore (_)."
        fi
    done
}

# --- Main ---
PROJECT="${1:-}"
ROLE="${2:-}"

# Validate or ask for PROJECT
if [[ -z "$PROJECT" ]]; then
    ask_input PROJECT "Enter project name"
elif ! [[ "$PROJECT" =~ $VALID_REGEX ]]; then
    echo "Invalid project name. Allowed: letters, numbers, -, _"
    exit 1
fi

# Validate or ask for ROLE
if [[ -z "$ROLE" ]]; then
    ask_input ROLE "Enter role"
elif ! [[ "$ROLE" =~ $VALID_REGEX ]]; then
    echo "Invalid role. Allowed: letters, numbers, -, _"
    exit 1
fi

DATE="$(date +%Y%m%d)"
PRIV_FILE="${DATE}-${PROJECT}-${ROLE}"
PUB_FILE="${PRIV_FILE}.pub"
COMMENT="${ROLE}@${DATE}-${PROJECT}"

# Check if private key file already exists
if [[ -e "$PRIV_FILE" ]]; then
    read -rp "File '$PRIV_FILE' already exists. Overwrite? (y/N) " ans
    if [[ ! "$ans" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
fi

# Generate key pair
ssh-keygen -t ed25519 -C "$COMMENT" -f "$PRIV_FILE" -N ""

echo "Private key: $PRIV_FILE"
echo "Public key:  $PUB_FILE"

cat "$PUB_FILE"
