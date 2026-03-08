#!/usr/bin/env bash
# state.sh

SECURITY_ROOT="$HOME/.git-security"
STATE_DIR="$SECURITY_ROOT/state"

mkdir -p "$STATE_DIR"

get_repo_mode() {

    local repo="$1"
    local file="$STATE_DIR/${repo}.mode"

    [[ -f "$file" ]] && cat "$file" || echo "SAFE"
}

set_repo_mode() {

    local repo="$1"
    local mode="$2"

    echo "$mode" > "$STATE_DIR/${repo}.mode"
}