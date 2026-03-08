#!/usr/bin/env bash
# git-brandmauer interactive menu (per-repo)

set -euo pipefail

PREFIX="/usr/local"
SHARE_DIR="$PREFIX/share/brandmauer"
SHAREDLIB_DIR="$SHARE_DIR/shared-lib"
source "$SHAREDLIB_DIR/logging.sh"

STATE_DIR="$HOME/.git-security/state"
REPO_LIST_FILE="$HOME/.git-security/repos.list"

# Путь к директории этого скрипта
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Путь к net-security относительно git-brandmauer
LIB_DIR="/usr/local/lib/brandmauer"
NET_DIR="$LIB_DIR/net"
              
# Цвета
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"
BOLD="\e[1m"

network_menu() {
    while true; do
        clear
        echo -e "${BOLD}${CYAN}====================================================${RESET}"
        echo -e "${BOLD}${CYAN}          NET-SECURITY CONTROL MENU                 ${RESET}"
        echo -e "${BOLD}${CYAN}====================================================${RESET}"
        echo " 1) Check network status"
        echo " 2) Pause network (safe mode)"
        echo " 3) PANIC MODE (emergency shutdown)"
        echo 
        echo -e " ${RED}0) Exit${RESET}"
        echo -e "${BOLD}${CYAN}====================================================${RESET}"
        echo -ne "${BOLD}${CYAN}Select option:  ${RESET}"

        read -r choice
        echo

        case "$choice" in
            1)
                "$NET_DIR/net-status.sh"
                ;;
            2)              
                "$NET_DIR/network-pause.sh"
                ;;
            3)
                echo -e "${YELLOW} PANIC MODE ACTIVATION ${RESET}"
                read -rp " Are you sure? (yes/no): " confirm
                case "${confirm,,}" in
                    y|yes)
                        "$NET_DIR/panic.sh"
                        ;;
                    n|no|"")
                        info " Panic cancelled"
                        ;;
                    *)
                        warn " Unknown answer: $confirm"
                        ;;
                esac
                ;;
            0)
                info " Returning to main menu..."
                return 0   # <-- вместо exit 0
                ;;
            *)
                error " Invalid option"
                ;;
         esac

         echo
         read -rp " Press Enter to continue..."
        clear
    done
}

network_menu