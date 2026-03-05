# =============================================================
# shared-lib/net.sh - Функция проверки состояния сетевого подключения
# -------------------------------------------------------------
# Использование net.sh
:<<'DOC'
# Использование
wait_net_up net_is_up
DOC
# =============================================================

# ---------------- CONFIG ----------------
PREFIX="/usr/local"
SHARE_DIR="$PREFIX/share/brandmauer"
SHAREDLIB_DIR="$SHARE_DIR/shared-lib"
source "$SHAREDLIB_DIR/logging.sh"

# -------------------------------------------------------------
# Защита от повторного подключения
# -------------------------------------------------------------
[[ -n "${_GS_NET_LOADED:-}" ]] && return 0
_GS_NET_LOADED=1

wait_net_up() {
    local check_func="${1:-}"  # допускаем пустое значение
    [[ -z "$check_func" ]] && { error " check function required"; return 1; }

    local retries=5
    local delay=10

    for ((i=1; i<=retries; i++)); do
        info " Checking network status (attempt $i/$retries)..."
        # вызываем функцию через команду `"$check_func"` в подпроцессе
        "$check_func"
        if [[ $? -eq 0 ]]; then
            ok " Network is UP"
            return 0
        fi
        warn " Network not ready, retrying in ${delay}s..."
        sleep "$delay"
    done

    error " Network did not come up after ${retries} attempts. Check network status."
    return 1
}

# -------------------------------------------------------------
# net_is_up() - проверяет текущее состояние сети
# возвращает 0, если сеть UP, 1 если DOWN
# -------------------------------------------------------------
net_is_up() {
    if nmcli networking | grep -q enabled; then
        return 0
    else
        return 1
    fi
}