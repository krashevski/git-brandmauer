#!/usr/bin/env bash
# =============================================================
# close_active_repos.sh — закрыть все OPEN/NORMAL репозитории
# =============================================================

set -euo pipefail

echo "DEBUG: close_active_repos.sh started"

PREFIX="/usr/local"

LIB_DIR="$PREFIX/lib/brandmauer/git"
source "$LIB_DIR/state.sh"

SHARE_DIR="$PREFIX/share/brandmauer"
SHAREDLIB_DIR="$SHARE_DIR/shared-lib"
source "$SHAREDLIB_DIR/logging.sh"

SECURITY_ROOT="$HOME/.git-security"
REPO_LIST="$SECURITY_ROOT/repos.list"

closed=0
skipped=0

[[ -f "$REPO_LIST" ]] || {
    warn "Repository list not found"
    exit 0
}

while IFS= read -r path || [[ -n "$path" ]]; do

    # пропуск пустых строк
    [[ -z "$path" ]] && continue

    # пропуск не git репозиториев
    [[ -d "$path/.git" ]] || continue

    repo=$(basename "$path")

    current_mode=$(get_repo_mode "$repo")

    case "$current_mode" in

        SAFE)
            ((skipped+=1))
            continue
        ;;

        OPEN|NORMAL)
            set_repo_mode "$repo" SAFE
            auto "$repo -> SAFE"
            ((closed+=1))
        ;;

        *)
            warn "$repo unknown mode: $current_mode"
        ;;

    esac

done < "$REPO_LIST"

info "Repositories closed: $closed"
info "Already SAFE: $skipped"