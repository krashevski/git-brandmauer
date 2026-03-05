#!/usr/bin/env bash
set -euo pipefail

PREFIX="/usr/local"
BIN_FILE="$PREFIX/bin/brandmauer"
LIB_DIR="$PREFIX/lib/brandmauer"
SHARE_DIR="$PREFIX/share/brandmauer"
SECURITY_ROOT="$HOME/.git-security"
STATE_DIR="$HOME/.local/share/brandmauer/state"

SHARE_DIR="$PREFIX/share/brandmauer"
SHAREDLIB_DIR="$SHARE_DIR/shared-lib"
source "$SHAREDLIB_DIR/logging.sh"

echo "========================================"
echo "        BRANDMAUER UNINSTALLER"
echo "========================================"

# --- удаляем CLI ---
if [[ -f "$BIN_FILE" ]]; then
    info " Removing CLI..."
    sudo rm -f "$BIN_FILE"
fi

# --- удаляем библиотеку ---
if [[ -d "$LIB_DIR" ]]; then
    info " Removing library..."
    sudo rm -rf "$LIB_DIR"
fi

# --- удаляем share ---
if [[ -d "$SHARE_DIR" ]]; then
    info " Removing shared data..."
    sudo rm -rf "$SHARE_DIR"
fi

# --- удаляем share ---
if [[ -d "$SECURITY_ROOT" ]]; then
    info " Removing git-security data..."
    sudo rm -rf "$SECURITY_ROOT"
fi


echo "[OK] System files removed."

# --- спрашиваем про пользовательские данные ---
if [[ -d "$STATE_DIR" ]]; then
    echo
    read -rp "Remove user state directory ($STATE_DIR)? [y/N]: " confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        rm -rf "$STATE_DIR"
        info " User state removed."
    else
        info " User state preserved."
    fi
fi

echo
ok " Brandmauer uninstalled."