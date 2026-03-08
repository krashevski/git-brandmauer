#!/usr/bin/env bash
# activity.sh

get_last_activity() {

    local repo="$1"

    [[ -d "$repo/.git" ]] || return 1

    if [[ -f "$repo/.git/index" ]]; then
        stat -c %Y "$repo/.git/index"
    else
        stat -c %Y "$repo/.git/HEAD"
    fi
}