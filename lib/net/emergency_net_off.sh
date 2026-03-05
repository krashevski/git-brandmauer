#!/usr/bin/env bash
# emergency_net_off.sh — немедленно отключить сеть

set -euo pipefail

# Подключаем core/init.sh Brandmauer
PREFIX="/usr/local"
LIB_DIR="$PREFIX/lib/brandmauer"
source "$LIB_DIR/core/init.sh"

SHARE_DIR="$PREFIX/share/brandmauer"
SHAREDLIB_DIR="$SHARE_DIR/shared-lib"
source "$SHAREDLIB_DIR/logging.sh"

security " Emergency network shutdown..."
nmcli networking off

action " Network disabled (emergency)"