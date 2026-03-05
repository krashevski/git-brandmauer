#!/usr/bin/env bash
# =============================================================
# net-status.sh — network status (Brandmauer v1.0)
# =============================================================

set -euo pipefail

# Подключаем init.sh Brandmauer для определения путей
PREFIX="/usr/local"
LIB_DIR="$PREFIX/lib/brandmauer"
source "$LIB_DIR/core/init.sh"

LOG_DIR="$HOME/.local/share/brandmauer/logs"
LOG_FILE="$LOG_DIR/net-status.log"
mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%F %T')] $*" >> "$LOG_FILE"
}

echo "=== Network status ==="
nmcli networking
echo

echo "=== Active connections ==="
nmcli device status
echo

log "Checked network status"
