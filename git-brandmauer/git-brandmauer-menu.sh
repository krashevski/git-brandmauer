#!/usr/bin/env bash
# git-brandmauer interactive menu

set -euo pipefail

STATE_DIR="$HOME/.git-security/state"

# Список репозиториев (можно редактировать)
REPOS=("git-guides" "git-security" "media-panel-template" "REBK" "shared-lib")
MODES=("OPEN" "SAFE" "ONLY_PUSH")

show_menu() {
    # Читаем глобальный режим
    GLOBAL_MODE="UNKNOWN"
    GLOBAL_FILE="$STATE_DIR/mode"
    if [[ -f "$GLOBAL_FILE" ]]; then
        GLOBAL_MODE=$(<"$GLOBAL_FILE")
    fi

    echo "================ git-brandmauer menu ================"
    echo "Select repository to manage:"

    for i in "${!REPOS[@]}"; do
        repo="${REPOS[$i]}"
        mode_file="$STATE_DIR/${repo}.mode"
        if [[ -f "$mode_file" ]]; then
            current_mode=$(<"$mode_file")
        else
            current_mode="$GLOBAL_MODE"
        fi
        echo "  $((i+1))) $repo (mode: $current_mode)"
    done

    echo "  0) Exit"
    echo "===================================================="
}

select_repo() {
    read -rp "Enter number: " choice
    if [[ "$choice" == "0" ]]; then
        exit 0
    fi
    if (( choice < 1 || choice > ${#REPOS[@]} )); then
        echo "[ERROR] Invalid choice"
        return 1
    fi
    REPO="${REPOS[$((choice-1))]}"
}

select_mode() {
    echo "Select mode for $REPO:"
    for i in "${!MODES[@]}"; do
        echo "  $((i+1))) ${MODES[$i]}"
    done
    read -rp "Enter number: " choice
    if (( choice < 1 || choice > ${#MODES[@]} )); then
        echo "[ERROR] Invalid choice"
        return 1
    fi
    MODE="${MODES[$((choice-1))]}"
}

# ========== MAIN LOOP ==========
while true; do
    show_menu
    select_repo || continue
    select_mode || continue

    git-brandmauer-mode "$REPO" "$MODE"
    echo "[INFO] $REPO set to $MODE"
    echo
done