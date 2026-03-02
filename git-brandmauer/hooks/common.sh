#!/usr/bin/env bash
# common.sh - mode definition script, policy core
# ✔ Всегда возвращает одно валидное значение
# ✔ Fail-safe (SAFE по умолчанию)
# ✔ Готов к расширению режимов

set -euo pipefail

SECURITY_ROOT="$HOME/.git-security"
STATE_DIR="$SECURITY_ROOT/state"
MODE_FILE="$STATE_DIR/mode"

get_git_mode() {
    local repo
    repo="$(basename "$(git rev-parse --show-toplevel 2>/dev/null || echo "")")"
    local mode_file="$HOME/.git-security/state/${repo}.mode"
    # Проверка per-repo режима
    mode_file="$HOME/.git-security/state/$(basename "$(git rev-parse --show-toplevel)").mode"

    if [[ -f "$mode_file" ]]; then
        mode="$(<"$mode_file")"
    else
        mode="$(<"$HOME/.git-security/state/global_mode" 2>/dev/null || echo "SAFE")"
    fi

    case "$mode" in
        OPEN|SAFE|NORMAL|ONLY_PUSH)
            echo "$mode"
            ;;
        *)
            echo "SAFE"
            ;;
    esac
}

die_security() {
    echo "[SECURITY] $1" >&2
    exit 1
}
