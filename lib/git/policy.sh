#!/usr/bin/env bash
# policy.sh

apply_idle_policy() {

    local idle="$1"
    local timeout="$2"
    local current_mode="$3"

    if (( idle > timeout )) && [[ "$current_mode" != "SAFE" ]]; then
        return 0   # нужно переключить SAFE
    fi

    return 1
}