#!/usr/bin/env bash
# git-brandmauer uninstall script

set -euo pipefail

SECURITY_ROOT="$HOME/.git-security"

echo "[INFO] Removing git-brandmauer core..."

# 1. Убираем hooksPath
git config --global --unset core.hooksPath || true

# 2. Удаляем core
rm -rf "$SECURITY_ROOT"

echo "[OK] git-brandmauer core removed"