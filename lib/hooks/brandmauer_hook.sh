#!/usr/bin/env bash
# /usr/local/share/brandmauer/hooks/brandmauer_hook.sh

set -euo pipefail

PREFIX="/usr/local"
AUTO_SCRIPT="$PREFIX/lib/brandmauer/git/automatic_safe.sh"

[[ -x "$AUTO_SCRIPT" ]] || exit 0

# не ломаем git если что-то пошло не так
"$AUTO_SCRIPT" >/dev/null 2>&1 || true