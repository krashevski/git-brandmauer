#!/usr/bin/env bash
# =============================================================
# ui/settings_menu.sh — интерактивное меню Brandmauer для Automatic SAFE
# -------------------------------------------------------------

set -euo pipefail

PREFIX="/usr/local"
LIB_DIR="$PREFIX/lib/brandmauer"
GIT_DIR="$LIB_DIR/git"
AUTO_SCRIPT="$GIT_DIR/automatic_safe.sh"

SHARE_DIR="$PREFIX/share/brandmauer"
SHAREDLIB_DIR="$SHARE_DIR/shared-lib"
source "$SHAREDLIB_DIR/logging.sh"

SECURITY_ROOT="$HOME/.git-security"
AUTO_FILE="$SECURITY_ROOT/automatic"
TIME_FILE="$SECURITY_ROOT/automatic.time"

DEFAULT_TIMEOUT=150

# Цвета
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"
BOLD="\e[1m"

# ================= MAIN LOOP =================
while true; do
    clear
    echo -e "${BOLD}${CYAN}====================================================${NC}"
    echo -e "${BOLD}${CYAN}               BRANDMAUER SETTINGS                  ${NC}"
    echo -e "${BOLD}${CYAN}====================================================${NC}"

    # Текущий статус Automatic SAFE
    auto_state="OFF"
    [[ -f "$AUTO_FILE" ]] && auto_state="$(<"$AUTO_FILE")"

    timeout="$DEFAULT_TIMEOUT"
    [[ -f "$TIME_FILE" ]] && timeout="$(<"$TIME_FILE")"

    echo " Automatic SAFE: $auto_state"
    echo " Idle timeout: $timeout sec"
    echo
    echo "   1) Toggle Automatic SAFE"
    echo "   2) Set idle timeout"
    echo
    echo -e " ${RED}0) Back ${NC}"
    echo -e "${BOLD}${CYAN}====================================================${NC}"

    read -rp "Enter choice: " choice

    case "$choice" in

    1)
        if [[ "$auto_state" == "ON" ]]; then
            echo "OFF" > "$AUTO_FILE"
            info "Automatic SAFE disabled"
        else
            echo "ON" > "$AUTO_FILE"
            info "Automatic SAFE enabled"
        fi
        ;;

    2)
        read -rp "Enter timeout seconds: " new_time
        if [[ "$new_time" =~ ^[0-9]+$ ]]; then
            echo "$new_time" > "$TIME_FILE"
            info "Timeout updated to $new_time sec"
        else
            error "Invalid number entered"
        fi
        ;;
    0)
        break
        ;;

    *)
        warn "Invalid choice: $choice"
        ;;

    esac

    echo
done