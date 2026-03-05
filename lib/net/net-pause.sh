#!/usr/bin/env bash
# =============================================================
# net_pause.sh — временно приостановить сеть для git-security
# =============================================================

set -euo pipefail

# подключаем init и shared-lib
PREFIX="/usr/local"
LIB_DIR="$PREFIX/lib/brandmauer"
source "$LIB_DIR/core/init.sh"

SHARE_DIR="$PREFIX/share/brandmauer"
SHAREDLIB_DIR="$SHARE_DIR/shared-lib"
source "$SHAREDLIB_DIR/net.sh"
source "$SHAREDLIB_DIR/logging.sh"

security " Pausing network..."
nmcli networking off

# ждём, пока сеть реально станет DOWN
net_is_down() {
    ! net_is_up
}

wait_net_up net_is_down || true

ok " Network paused"