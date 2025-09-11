#!/bin/zsh

# Archivo: ~/.zsh/scripts/load_shares.sh

MOUNT_POINT="/mnt/nas_earth"
NAS_SHARE="//nas.knet/all"
NAS_USER="kmi"
PASS_PATH="systems/smbuser/smb_kmi"  # Ruta en pass

# --- Función para validar root ---
require_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "❌ Este script debe ejecutarse como root" >&2
        exit 1
    fi
}

# --- Función para montar ---
mount_share() {
    echo "🔗 Montando NAS en $MOUNT_POINT" >&2
    # Chequeo si ya está montado
    if mountpoint -q "$MOUNT_POINT"; then
        echo "⚠️ $MOUNT_POINT ya está montado." >&2
        exit 0
    fi
    mkdir -p "$MOUNT_POINT"
    # Obtener contraseña directamente desde pass
    if ! SMB_PASS=$(pass show "$PASS_PATH" 2>/dev/null); then
        echo "❌ No se pudo obtener contraseña desde pass ($PASS_PATH)" >&2
        exit 1
    fi
    sudo mount -t cifs "$NAS_SHARE" "$MOUNT_POINT" \
        -o username=$NAS_USER,password=$SMB_KMI,uid=$(id -u),gid=$(id -g),noperm
        # -o username=$NAS_USER,password=$SMB_KMI,uid=$(id -u),gid=$(id -g),file_mode=0664,dir_mode=0775

    mkdir -p /mnt/netsystems
    # sudo mount -t nfs 10.10.10.49:/mnt/pve/hdd_local/netsystems /mnt/netsystems
}

# --- Función para desmontar ---
umount_share() {
    echo "🔌 Desmontando NAS de $MOUNT_POINT" >&2
    # Chequeo si realmente está montado
    if ! mountpoint -q "$MOUNT_POINT"; then
        echo "⚠️ $MOUNT_POINT no está montado." >&2
        exit 0
    fi

    sudo umount "$MOUNT_POINT" || {
        echo "⚠️ No se pudo desmontar $MOUNT_POINT (¿ya está desmontado?)." >&2
        exit 1
    }
}

# --- Lógica principal ---
# require_root

case "$1" in
    up)
        mount_share
        ;;
    down)
        umount_share
        ;;
    *)
        echo "Uso: $0 {up|down}" >&2
        exit 1
        ;;
esac

