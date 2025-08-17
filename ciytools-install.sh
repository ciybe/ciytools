#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/ciybe/ciytools.git"
TARGET_DIR="/opt/ciytools"
SCRIPT_PATH="$TARGET_DIR/scripts"

# Detect user (non-root if sudo is used)
USER_NAME=${SUDO_USER:-$USER}
USER_HOME=$(eval echo ~$USER_NAME)
BASHRC="$USER_HOME/.bashrc"

function ensure_git() {
    if ! command -v git >/dev/null 2>&1; then
        echo "[*] Installing git ..."
        sudo apt-get update && sudo apt-get install -y git
    fi
}

function clone_or_update_repo() {
    if [ -d "$TARGET_DIR/.git" ]; then
        echo "[*] Updating repo in $TARGET_DIR ..."
        git -C "$TARGET_DIR" pull --ff-only || {
            echo "[!] git pull failed, resetting ..."
            git -C "$TARGET_DIR" fetch --all
            git -C "$TARGET_DIR" reset --hard origin/main
        }
    else
        echo "[*] Cloning repo into $TARGET_DIR ..."
        sudo mkdir -p "$TARGET_DIR"
        sudo git clone "$REPO_URL" "$TARGET_DIR"
        sudo chown -R "$USER_NAME":"$USER_NAME" "$TARGET_DIR"
    fi
}

function configure_path() {
    if ! grep -q "$SCRIPT_PATH" "$BASHRC"; then
        echo "" >> "$BASHRC"
        echo "# ciytools" >> "$BASHRC"
        echo "export PATH=\$PATH:$SCRIPT_PATH" >> "$BASHRC"
        echo "[*] Added PATH line to $BASHRC"
    else
        echo "[*] PATH already configured in $BASHRC"
    fi
}

ensure_git
clone_or_update_repo
configure_path

echo "[*] Setup complete. Reload your shell with: source $BASHRC"
