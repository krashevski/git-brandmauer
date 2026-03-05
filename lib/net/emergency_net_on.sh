#!/usr/bin/env bash
# =============================================================
# emergency_net_on.sh — включить сеть обратно (Brandmauer v1.0)
# =============================================================

set -euo pipefail

# Подключаем core/init.sh Brandmauer
PREFIX="/usr/local"
LIB_DIR="$PREFIX/lib/brandmauer"
source "$LIB_DIR/core/init.sh"

SHARE_DIR="$PREFIX/share/brandmauer"
SHAREDLIB_DIR="$SHARE_DIR/shared-lib"
source "$SHAREDLIB_DIR/net.sh"
source "$SHAREDLIB_DIR/logging.sh"

# Каталоги для net
NET_DIR="$LIB_DIR/net"
STATE_DIR="$HOME/.local/share/brandmauer/state"
STATE_FILE="$STATE_DIR/state"
LOG_DIR="$HOME/.local/share/brandmauer/logs"
LOG_FILE="$LOG_DIR/git-security.log"

mkdir -p "$LOG_DIR"

security " Restoring network..."
echo "[$(date '+%F %T')] Network restore initiated" >> "$LOG_FILE"

# Включаем сеть
nmcli networking on

# Ждём, пока сеть реально станет доступна
if ! wait_net_up net_is_up; then
    warn " Network may not be fully up yet"
    echo "[$(date '+%F %T')] Warning: network may not be fully up" >> "$LOG_FILE"
else
    ok " Network enabled and verified"
    echo "[$(date '+%F %T')] Network successfully restored" >> "$LOG_FILE"
fi