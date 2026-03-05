#!/usr/bin/env bash
# =============================================================
# network-pause.sh — central network pause controller
# Brandmauer v1.0
# =============================================================

set -euo pipefail

# Цвета
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"
BOLD="\e[1m"

# Подключаем init.sh Brandmauer
PREFIX="/usr/local"
LIB_DIR="$PREFIX/lib/brandmauer"
NET_DIR="$LIB_DIR/net"
source "$LIB_DIR/core/init.sh"

SHARE_DIR="$PREFIX/share/brandmauer"
SHAREDLIB_DIR="$SHARE_DIR/shared-lib"
source "$SHAREDLIB_DIR/net.sh"
source "$SHAREDLIB_DIR/logging.sh"

LOG_DIR="$HOME/.local/share/brandmauer/logs"
mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%F %T')] $*" >> "$LOG_DIR/network-pause.log"
}

info " Checking network status..."

if net_is_up; then
    security " Network is ENABLED"
    action " Disabling network access..."
    "$NET_DIR/emergency_net_off.sh"
    ok " Network paused successfully"
    log "Network paused"
else
    security " Network is already DISABLED"
    read -rp " Do you want to turn on the network now? [y/N]: " answer
    answer="${answer,,}"  # в нижний регистр

    case "$answer" in
        y|yes)
            info " Enabling network..."
            "$NET_DIR/emergency_net_on.sh"
            wait_net_up "$NET_DIR/net_check.sh" || true
            log "Network re-enabled by user"
            ;;
        n|no|"")
            info " Network remains disabled"
            info " To re-enable later run:"
            echo "       $NET_DIR/emergency_net_on.sh"
            log "Network remains disabled"
            ;;
        *)
            warn " Invalid answer. Network remains disabled."
            info " To enable manually run:"
            echo_msg "       $NET_DIR/emergency_net_on.sh"
            log "Invalid input, network left disabled"
            ;;
    esac
fi