#!/usr/bin/env bash
# =============================================================
# shared-lib/logging.sh — эталонная библиотека логирования REBK
# -------------------------------------------------------------
# Использование logging.sh
:<<'DOC'
info dispatcher_started
ok operation_completed
warn low_disk_space
error something_wrong || true
die 2 fatal_error
DOC

set -o errexit
set -o pipefail

# -------------------------------------------------------------
# Защита от повторного подключения
# -------------------------------------------------------------
[[ -n "${_GS_LOGGING_LOADED:-}" ]] && return 0
# shellcheck disable=SC2034
_GS_LOGGING_LOADED=1

# -------------------------------------------------------------
# Цвета
# -------------------------------------------------------------
if [[ "${FORCE_COLOR:-0}" == "1" || -t 1 ]]; then
    RED="\033[0;31m"
    GREEN="\033[0;32m"
    YELLOW="\033[1;33m"
    BLUE="\033[0;34m"
    NC="\033[0m"
    MAGENTA="\033[0;35m"
else
    RED=""; GREEN=""; YELLOW=""; BLUE=""; NC=""; MAGENTA=""
fi

# -------------------------------------------------------------
# i18n
# -------------------------------------------------------------
declare -Ag MSG

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$LIB_DIR/.." && pwd)"

say() {
    local key="$1"; shift
    local msg="${MSG[$key]:-$key}"
    [[ $# -gt 0 ]] && printf "$msg" "$@" || printf '%s' "$msg"
}

echo_msg() {
    say "$@"
    printf "\n"
}

# -------------------------------------------------------------
# Лог-функции уровни логирования
# -------------------------------------------------------------
: "${RUN_LOG:=/dev/null}"

ok() {
    printf "%b[OK]%b %b\n" "$GREEN" "$NC" "$(say "$@")" | tee -a "$RUN_LOG"
}

info() {
    printf "%b[INFO]%b %b\n" "$BLUE" "$NC" "$(say "$@")" | tee -a "$RUN_LOG"
}

warn() {
    printf "%b[WARN]%b %b\n" "$YELLOW" "$NC" "$(say "$@")" | tee -a "$RUN_LOG" >&2
}

error() {
    printf "%b[ERROR]%b %b\n" "$RED" "$NC" "$(say "$@")" | tee -a "$RUN_LOG" >&2
    return 1
}

die() {
    local code=1
    [[ "$1" =~ ^[0-9]+$ ]] && { code="$1"; shift; }
    printf "%b[ERROR]%b %b\n" "$RED" "$NC" "$(say "$@")" | tee -a "$RUN_LOG" >&2
    exit "$code"
}

# -------------------------------------------------------------
# Категории событий
# -------------------------------------------------------------
security() {
    printf "%b[SECURITY]%b %b\n" "$MAGENTA" "$NC" "$(say "$@")" | tee -a "$RUN_LOG"
}

action() {
    printf "%b[ACTION]%b %b\n" "$BLUE" "$NC" "$(say "$@")" | tee -a "$RUN_LOG"
}

auto() {
    printf "%b[AUTO]%b %b\n" "$MAGENTA" "$NC" "$(say "$@")" | tee -a "$RUN_LOG"
}

# -------------------------------------------------------------
# Экспорт say как readonly API
# -------------------------------------------------------------
readonly -f say ok info warn error die auto security action