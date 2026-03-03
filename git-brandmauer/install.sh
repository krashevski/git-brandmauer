#!/usr/bin/env bash
# =============================================================
# Git-Brandmauer 2.1 — Production Installer (hooks-only)
# =============================================================

set -euo pipefail

# ================= CONFIG =================
SECURITY_ROOT="$HOME/.git-security"
HOOKS_DIR="$SECURITY_ROOT/hooks"
STATE_DIR="$SECURITY_ROOT/state"
BIN_DIR="$HOME/.local/bin"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_SRC="$SCRIPT_DIR/hooks"
COMMON_SRC="$SCRIPT_DIR/common.sh"
MODE_SRC="$SCRIPT_DIR/git-brandmauer-mode"

COMMON_DST="$SECURITY_ROOT/common.sh"
MODE_DST="$BIN_DIR/git-brandmauer-mode"

REAL_GIT="$(command -v git)"

# ================= LOGGING =================
info() { printf "[INFO] %s\n" "$*"; }
warn() { printf "[WARN] %s\n" "$*" >&2; }
error() { printf "[ERROR] %s\n" "$*" >&2; exit 1; }

# ================= VALIDATION =================
require_git() {
    [[ -n "$REAL_GIT" ]] || error "Git not found in PATH"
}

validate_mode_file() {
    local file="$1"
    local mode
    mode="$(cat "$file")"
    case "$mode" in
        SAFE|NORMAL|OPEN) ;;
        *)
            warn "Invalid mode detected in $file → resetting to SAFE"
            echo "SAFE" > "$file"
            ;;
    esac
}

# ================= INSTALL STEPS =================
create_directories() {
    info "Creating directories"
    mkdir -p "$HOOKS_DIR" "$STATE_DIR" "$BIN_DIR"
}

install_hooks() {
    [[ -d "$HOOKS_SRC" ]] || error "Hooks source not found: $HOOKS_SRC"

    info "Installing hooks"
    cp -f "$HOOKS_SRC"/* "$HOOKS_DIR/"
    chmod +x "$HOOKS_DIR"/*
}

install_policy_engine() {
    [[ -f "$COMMON_SRC" ]] || error "common.sh not found"

    info "Installing policy engine"
    cp -f "$COMMON_SRC" "$COMMON_DST"
    chmod 0644 "$COMMON_DST"
}

install_mode_switcher() {
    [[ -f "$MODE_SRC" ]] || error "git-brandmauer-mode not found"

    info "Installing mode switcher"
    cp -f "$MODE_SRC" "$MODE_DST"
    chmod +x "$MODE_DST"
}

configure_git() {
    info "Configuring global hooksPath"
    "$REAL_GIT" config --global core.hooksPath "$HOOKS_DIR"
}

initialize_global_mode() {
    local file="$STATE_DIR/global_mode"

    if [[ ! -f "$file" ]]; then
        info "Initializing global mode → SAFE"
        echo "SAFE" > "$file"
    fi

    validate_mode_file "$file"
}

# ================= SELF-CHECK =================
self_check() {
    info "Running self-check"

    local ok=true

    if [[ "$("$REAL_GIT" config --global core.hooksPath)" != "$HOOKS_DIR" ]]; then
        warn "hooksPath mismatch"
        ok=false
    fi

    [[ -r "$COMMON_DST" ]] || { warn "common.sh missing"; ok=false; }
    [[ -x "$MODE_DST" ]] || { warn "mode switcher missing"; ok=false; }

    if command -v git-brandmauer-mode >/dev/null 2>&1; then
        :
    else
        warn "git-brandmauer-mode not in PATH"
        ok=false
    fi

    if $ok; then
        info "Self-check passed"
    else
        warn "Self-check detected issues"
    fi
}

# ================= MAIN =================
main() {
    info "Git-Brandmauer 2.1 installation started"

    require_git
    create_directories
    install_hooks
    install_policy_engine
    install_mode_switcher
    configure_git
    initialize_global_mode
    self_check

    info "Installation complete"
    info "Current global mode: $(cat "$STATE_DIR/global_mode")"
}

main "$@"