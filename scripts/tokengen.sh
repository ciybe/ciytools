#!/usr/bin/env bash
set -euo pipefail

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
BASENAME="${DATE}-${PROJECT}-${ROLE}"
TOKEN_FILE="${BASENAME}.token"

echo
echo "➡ Use this identifier when creating the token on the website:"
echo "   ${BASENAME}"
echo

# Ask for token securely
read -rsp "Enter API token: " TOKEN
echo
if [[ -z "$TOKEN" ]]; then
    echo "No token entered. Aborted."
    exit 1
fi

# Check for overwrite
if [[ -e "$TOKEN_FILE" ]]; then
    read -rp "File '$TOKEN_FILE' already exists. Overwrite? (y/N) " ans
    if [[ ! "$ans" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
fi

# Store token
printf "%s\n" "$TOKEN" > "$TOKEN_FILE"
chmod 600 "$TOKEN_FILE"

echo "✅ Token stored in: $TOKEN_FILE"
