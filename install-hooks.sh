#!/usr/bin/env bash
# smart-install-hooks.sh — установка и обновление git hooks для git-brandmauer
# обновляет только изменённые хуки, не перезаписывая рабочие

set -euo pipefail

# ---------------- CONFIG ----------------
PREFIX="/usr/local"
LIB_DIR="$PREFIX/lib/brandmauer"
HOOKS_SRC="$LIB_DIR/hooks"
HOOKS_DEST="$HOME/.git-security/hooks"

mkdir -p "$HOOKS_DEST"

# ---------------- LOGGING ----------------
info() { echo "[INFO] $*"; }
warn() { echo "[WARN] $*" >&2; }
error() { echo "[ERROR] $*" >&2; exit 1; }

echo "[INFO] Checking hooks in $HOOKS_DEST..."

for hook in "$HOOKS_SRC"/*; do
    hook_name=$(basename "$hook")
    dest_hook="$HOOKS_DEST/$hook_name"

    # Если файла нет — копируем
    if [[ ! -f "$dest_hook" ]]; then
        cp "$hook" "$dest_hook"
        chmod +x "$dest_hook"
        echo "[INFO] Installed new hook: $hook_name"
        continue
    fi

    # Если файл есть — сравниваем содержимое
    if ! cmp -s "$hook" "$dest_hook"; then
        echo "[INFO] Updating hook: $hook_name"
        cp "$hook" "$dest_hook"
        chmod +x "$dest_hook"
    else
        echo "[INFO] Hook up-to-date: $hook_name"
    fi
done

echo "[INFO] All hooks checked and updated successfully."