#!/usr/bin/env bash
# =============================================================
# automatic_safe.sh — автоматическая проверка и перевод репозиториев в SAFE
# =============================================================

set -euo pipefail

PREFIX="/usr/local"
LIB_DIR="$PREFIX/lib/brandmauer/git"
source "$LIB_DIR/activity.sh"
source "$LIB_DIR/policy.sh"
source "$LIB_DIR/state.sh"

SHARE_DIR="$PREFIX/share/brandmauer"
SHAREDLIB_DIR="$SHARE_DIR/shared-lib"
source "$SHAREDLIB_DIR/logging.sh"

SECURITY_ROOT="$HOME/.git-security"
STATE_DIR="$SECURITY_ROOT/state"

AUTO_FILE="$SECURITY_ROOT/automatic"
TIME_FILE="$SECURITY_ROOT/automatic.time"
LAST_RUN_FILE="$SECURITY_ROOT/auto_last_run"

DEFAULT_TIMEOUT=150
SCAN_INTERVAL=30

# Проверка, включен ли автоматический SAFE
[[ -f "$AUTO_FILE" ]] || exit 0
[[ "$(cat "$AUTO_FILE")" == "ON" ]] || exit 0

# Определяем таймаут
TIMEOUT="$DEFAULT_TIMEOUT"
[[ -f "$TIME_FILE" ]] && TIMEOUT="$(cat "$TIME_FILE")"

NOW=$(date +%s)

# Проверка последнего запуска
if [[ -f "$LAST_RUN_FILE" ]]; then
    last=$(cat "$LAST_RUN_FILE")
    if (( NOW - last < SCAN_INTERVAL )); then
        exit 0
    fi
fi
echo "$NOW" > "$LAST_RUN_FILE"

# Проверяем, есть ли список репозиториев
REPO_LIST="$SECURITY_ROOT/repos.list"
[[ -f "$REPO_LIST" ]] || exit 0

while IFS= read -r path || [[ -n "$path" ]]; do

    [[ -z "$path" ]] && continue
    [[ -d "$path/.git" ]] || continue

    repo=$(basename "$path")

    current_mode=$(get_repo_mode "$repo")

    [[ "$current_mode" == "SAFE" ]] && continue

    last_activity=$(get_last_activity "$path")
    [[ -n "$last_activity" ]] || continue
    idle=$(( NOW - last_activity ))

    if apply_idle_policy "$idle" "$TIMEOUT" "$current_mode"; then
        set_repo_mode "$repo" SAFE
        auto "$repo -> SAFE (idle ${idle}s)"
    fi
done < "$REPO_LIST"