#!/usr/bin/env bash

SECURITY_ROOT="$HOME/.git-security"
STATE_DIR="$SECURITY_ROOT/state"
REAL_GIT="/usr/bin/git"
COMMON="$SECURITY_ROOT/common.sh"

[[ -f "$COMMON" ]] || { echo "[ERROR] common.sh missing"; exit 1; }
source "$COMMON"

REPO=$(basename "$($REAL_GIT rev-parse --show-toplevel 2>/dev/null || echo '')")
MODE_FILE="$STATE_DIR/${REPO}.mode"

echo "Current directory: $(pwd)"
echo "Repo name detected: $REPO"
echo "Mode file: $MODE_FILE"

if [[ -f "$MODE_FILE" ]]; then
    MODE=$(<"$MODE_FILE")
else
    MODE="SAFE"
fi

echo "Mode detected: $MODE"

# Тестируем команды
for TEST_CMD in push pull merge fetch; do
    echo -n "Testing $TEST_CMD: "
    enforce_git_policy "$TEST_CMD" && echo "ALLOWED" || echo "BLOCKED"
done