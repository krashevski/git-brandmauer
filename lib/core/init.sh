#!/usr/bin/env bash
# core/init.sh — инициализация Brandmauer v1.0

set -euo pipefail

# Цвета
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"
BOLD="\e[1m"

PREFIX="/usr/local"
SHARE_DIR="$PREFIX/share/brandmauer"
SHAREDLIB_DIR="$SHARE_DIR/shared-lib"
source "$SHAREDLIB_DIR/logging.sh"

# Каталог с бинарниками CLI (brandmauer-git, brandmauer-net)
BASE_DIR="/usr/local/bin"
BIN_DIR="$PREFIX/bin"

# Каталог библиотеки
LIB_DIR="$PREFIX/lib/brandmauer"
SHARE_DIR="$PREFIX/share/brandmauer"
HOOKS_DIR="$SHARE_DIR/hooks"
SECURITY_ROOT="$HOME/.git-security"
STATE_DIR="$SECURITY_ROOT/state"
LOG_DIR="$HOME/.local/share/brandmauer/logs"

# -------- LOGGING --------
log() {
    mkdir -p "$LOG_DIR"
    echo "[$(date '+%F %T')] $*" >> "$LOG_DIR/init.log"
}

# -------- CREATE DIRS --------
mkdir -p "$STATE_DIR" "$HOOKS_DIR" "$LOG_DIR"

# -------- GLOBAL MODE --------
GLOBAL_MODE_FILE="$STATE_DIR/global_mode"
if [[ ! -f "$GLOBAL_MODE_FILE" ]]; then
    echo "SAFE" > "$GLOBAL_MODE_FILE"
    log "Initialized global_mode → SAFE"
fi

log "Brandmauer core initialized"

info " Brandmauer core initialized."
info " Directories created: $STATE_DIR, $SHARE_DIR, $HOOKS_DIR, $LOG_DIR"
info " Global mode file: $GLOBAL_MODE_FILE"
echo -e "${BOLD}${CYAN}----------------------------------------------------${RESET}"