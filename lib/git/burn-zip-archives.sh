#!/usr/bin/env bash
# =============================================================
# burn-zip-archives.sh — запись ZIP-архивов на CD/DVD (Brandmauer v1.0)
# =============================================================

set -euo pipefail

PREFIX="/usr/local"
SHARE_DIR="$PREFIX/share/brandmauer"
SHAREDLIB_DIR="$SHARE_DIR/shared-lib"
source "$SHAREDLIB_DIR/logging.sh"

# Подключаем init.sh Brandmauer для определения путей
LIB_DIR="$PREFIX/lib/brandmauer"
SCRIPT_DIR="$LIB_DIR/git"
source "$LIB_DIR/core/init.sh"

# Каталоги Brandmauer
LOG_DIR="$HOME/.local/share/brandmauer/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/burn-zip-archives.log"

log() {
    echo "[$(date '+%F %T')] $*" >> "$LOG_FILE"
}

# -------------------------------------------------------------
# Определяем целевой каталог для архивов
# -------------------------------------------------------------
TARGET_HOME="$HOME"
SOURCE_DIR="$TARGET_HOME/scripts"
[[ -d "$SOURCE_DIR" ]] || { error " SOURCE_DIR not found: $SOURCE_DIR"; exit 1; }

TMP_LIST="$(mktemp)"
DEVICE="$(ls /dev/sr* 2>/dev/null | head -n1)"
[[ -n "$DEVICE" ]] || { error " No optical drive found"; exit 1; }

cd "$SOURCE_DIR"

# Создаём SHA256-суммы всех ZIP
sha256sum *.zip > SHA256SUMS || { error " No zip files found"; exit 1; }

# Создаём MANIFEST
echo "Brandmauer backup $(date +%F)" > MANIFEST.txt

# Список архивов для записи
find "$SOURCE_DIR" -type f -name "*.zip" > "$TMP_LIST"

if [[ ! -s "$TMP_LIST" ]]; then
    error " No .zip archives found. Nothing to burn."
    rm -f "$TMP_LIST"
    exit 1
fi

# Создаём ISO
ISO_FILE="$TARGET_HOME/brandmauer-backup.iso"
mkisofs -R -J -o "$ISO_FILE" *.zip SHA256SUMS MANIFEST.txt
log "ISO created at $ISO_FILE"

ok " Archives ready to burn:"
cat "$TMP_LIST"

read -rp "Insert a blank CD/DVD and continue? (y/n): " answer
answer="${answer,,}"
answer="${answer%% *}"

if [[ "$answer" != "y" && "$answer" != "yes" ]]; then
    info " Operation cancelled."
    rm -f "$TMP_LIST"
    exit 0
fi

COUNT=$(wc -l < "$TMP_LIST")
info " Writing $COUNT archives to $DEVICE"
log "Writing $COUNT archives to $DEVICE"

# Запись ISO на диск
if wodim dev="$DEVICE" -v "$ISO_FILE"; then
    ok " Disc written successfully."
    log "Disc written successfully"
else
    error " Disc write failed!"
    log "Disc write failed"
    rm -f "$TMP_LIST"
    exit 1
fi

# Проверка SHA256
CD_MOUNT="$(mktemp -d)"
sudo mount -t iso9660 "$DEVICE" "$CD_MOUNT"
sha256sum -c "$CD_MOUNT/SHA256SUMS"
sudo umount "$CD_MOUNT"
rmdir "$CD_MOUNT"

rm -f "$TMP_LIST" "$ISO_FILE" SHA256SUMS MANIFEST.txt
log "Burn and verification completed"
ok " Burn and verification completed."