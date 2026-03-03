#!/usr/bin/env bash
# git-brandmauer interactive menu (per-repo)

set -euo pipefail

STATE_DIR="$HOME/.git-security/state"

REPO_LIST_FILE="$HOME/.git-security/repos.list"

init_repo_list() {
    if [[ ! -f "$REPO_LIST_FILE" ]]; then
        touch "$REPO_LIST_FILE"
    fi
}

MODES=("SAFE" "NORMAL" "OPEN")

# Цвета
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"
BOLD="\e[1m"

load_repos() {
    mapfile -t REPOS < "$REPO_LIST_FILE"
}

init_repo_list
load_repos

git_brandmauer_set_mode() {
    local repo="$1"
    local mode="$2"
    mkdir -p "$STATE_DIR"
    echo "$mode" > "$STATE_DIR/${repo}.mode"
}

mode_color() {
    case "$1" in
        SAFE) echo -e "$RED" ;;
        NORMAL) echo -e "$YELLOW" ;;
        OPEN) echo -e "$GREEN" ;;
        *) echo -e "$CYAN" ;;
    esac
}

show_menu() {
    echo -e "${BOLD}${CYAN}====================================================${RESET}"
    echo -e "               ${BOLD}${CYAN}GIT-BRANDMAUER MENU${RESET}"
    echo -e "${BOLD}${CYAN}====================================================${RESET}"
    echo -e "${BOLD}Select repository to manage:${RESET}"

    for i in "${!REPOS[@]}"; do
        repo="${REPOS[$i]}"
        mode_file="$STATE_DIR/${repo}.mode"

        if [[ -f "$mode_file" ]]; then
            current_mode=$(<"$mode_file")
        else
            current_mode="SAFE"
        fi

        color_mode=$(mode_color "$current_mode")

        echo -e "  $((i+1))) $repo (mode: ${color_mode}$current_mode${RESET})"
    done

    repo_count=${#REPOS[@]}
    manage_index=$((repo_count+1))

    echo
    echo -e "  $manage_index) Manage repositories"
    echo
    echo -e "  0) Exit"
    echo -e "${BOLD}${CYAN}====================================================${RESET}"
}

manage_repositories() {
    while true; do
        echo
        echo -e "${BOLD}${CYAN}====================================================${RESET}"
        echo -e "              ${BOLD}${CYAN}Repository manager ${RESET}"
        echo -e "${BOLD}${CYAN}====================================================${RESET}"
        echo " 1) Add repository"
        echo " 2) Remove repository"
        echo " 3) List repositories"
        echo
        echo "4) Back"
        echo -e "${BOLD}${CYAN}====================================================${RESET}"
        read -rp "Select: " choice

        case "$choice" in
            1)
                read -rp "Enter repository name: " repo
                if grep -qx "$repo" "$REPO_LIST_FILE"; then
                    echo "Already exists."
                else
                    echo "$repo" >> "$REPO_LIST_FILE"
                    echo "Added."
                fi
                ;;
            2)
                read -rp "Enter repository name to remove: " repo
                grep -vx "$repo" "$REPO_LIST_FILE" > "$REPO_LIST_FILE.tmp"
                mv "$REPO_LIST_FILE.tmp" "$REPO_LIST_FILE"
                echo "Removed."
                ;;
            3)
                echo
                echo -e "${BOLD}${CYAN}====================================================${RESET}"
                 echo -e "              ${BOLD}${CYAN}List repositorys ${RESET}"
                echo -e "${BOLD}${CYAN}====================================================${RESET}"
                cat "$REPO_LIST_FILE"
                ;;
            4)
                break
                ;;
            *)
                echo "Invalid choice"
                ;;
        esac
    done
}

select_repo() {
    read -rp "$(echo -e ${BOLD}${CYAN}Enter number: ${RESET})" choice

    repo_count=${#REPOS[@]}
    manage_index=$((repo_count+1))

    # --- Exit ---
    if [[ "$choice" == "0" ]]; then
        echo "Exiting..."
        exit 0
    fi

    # --- Manage repositories ---
    if (( choice == manage_index )); then
        manage_repositories
        load_repos
        return 1
    fi

    # --- Validate repo selection ---
    if (( choice < 1 || choice > repo_count )); then
        echo -e "${RED}[ERROR] Invalid choice${RESET}"
        return 1
    fi

    REPO="${REPOS[$((choice-1))]}"
    echo -e "Selected repository: ${CYAN}$REPO${RESET}"
}

select_mode() {
    echo -e "${BOLD}Select mode for ${CYAN}$REPO${RESET}:"

    for i in "${!MODES[@]}"; do
        color_mode=$(mode_color "${MODES[$i]}")
        echo -e "  $((i+1))) ${color_mode}${MODES[$i]}${RESET}"
    done

    read -rp "$(echo -e ${BOLD}${CYAN}Enter number: ${RESET})" choice

    if (( choice < 1 || choice > ${#MODES[@]} )); then
        echo -e "${RED}[ERROR] Invalid choice${RESET}"
        return 1
    fi

    MODE="${MODES[$((choice-1))]}"
    git_brandmauer_set_mode "$REPO" "$MODE"

    echo -e "${CYAN}[INFO]${RESET} $REPO set to $(mode_color "$MODE")$MODE${RESET}"
}

while true; do
    show_menu
    select_repo || continue
    select_mode || continue
    echo
done