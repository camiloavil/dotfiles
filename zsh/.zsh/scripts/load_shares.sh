#!/bin/zsh

# Archivo: ~/.zsh/scripts/load_shares.sh

# --- Variables de configuración y colores ---
HOST_SMB="nas.knet"
MOUNT_POINT_SMB="/mnt/nas_earth"
NAS_SHARE_SMB="//$HOST_SMB/all"
ACCESS_PASS_PATH_SMB="systems/balcones/smbusers/smb_kmi"
SYMLINK_SMB="$HOME/nas_earth"

HOST_NFS="proxmox_balcones.knet"
MOUNT_POINT_NFS="/mnt/netsystems"
NAS_SHARE_NFS="$HOST_NFS:/mnt/pve/hdd_local/netsystems"
SYMLINK_NFS="$HOME/netsystems"

# Códigos de color ANSI
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
NC="\033[0m" # Sin color

# --- Funciones de Ayuda y Estado ---
show_help() {
    echo "Gestión de shares de red (SMB y NFS)"
    echo
    echo "Uso: $0 [opción] [tipo_de_share]"
    echo
    echo "Opciones:"
    echo "  up {smb|nfs|all}   Monta la share especificada o todas."
    echo "  down {smb|nfs|all} Desmonta la share especificada o todas."
    echo "  status             Verifica el estado de los montajes."
    echo "  -h, --help         Muestra esta ayuda."
    echo
    echo "Ejemplo:"
    echo "  $0 up smb"
    echo "  $0 down all"
    echo "  $0 status"
}

check_status() {
    echo -e "${YELLOW}--- Estado de los montajes ---${NC}"
    
    # Verificar SMB
    if mountpoint -q "$MOUNT_POINT_SMB"; then
        echo -e "${GREEN}✅ SMB: $MOUNT_POINT_SMB está montado.${NC}"
    else
        echo -e "${RED}❌ SMB: $MOUNT_POINT_SMB no está montado.${NC}"
    fi
    
    # Verificar NFS
    if mountpoint -q "$MOUNT_POINT_NFS"; then
        echo -e "${GREEN}✅ NFS: $MOUNT_POINT_NFS está montado.${NC}"
    else
        echo -e "${RED}❌ NFS: $MOUNT_POINT_NFS no está montado.${NC}"
    fi
    
    echo -e "${YELLOW}---${NC}"
}

# --- Funciones Auxiliares ---
require_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}❌ Este script debe ejecutarse como root.${NC}" >&2
        exit 1
    fi
}

check_nas_accessibility() {
    echo -n "🔍 Verificando la accesibilidad de la NAS en $HOST_SMB..." >&2
    if ! ping -c 1 -W 1 "$HOST_SMB" >/dev/null 2>&1; then
        echo -e "\n${RED}❌ La NAS no es accesible. No se puede continuar.${NC}" >&2
        exit 1
    fi
    echo -e "${GREEN}✅ accesible.${NC}" >&2
}

create_symlink() {
    local target="$1"
    local symlink="$2"
    if [[ ! -e "$symlink" ]]; then
        ln -s "$target" "$symlink"
        echo -e "${GREEN}🔗 Enlace simbólico creado: $symlink -> $target${NC}"
    fi
}

remove_symlink() {
    local symlink="$1"
    if [[ -L "$symlink" ]]; then
        rm "$symlink"
        echo -e "${YELLOW}❌ Enlace simbólico eliminado: $symlink${NC}"
    fi
}

# --- Funciones de Montaje ---
mount_smb_share() {
    check_nas_accessibility
    echo -e "🔗 Montando NAS SMB en ${YELLOW}$MOUNT_POINT_SMB${NC}..." >&2
    
    if mountpoint -q "$MOUNT_POINT_SMB"; then
        echo -e "${YELLOW}⚠️ $MOUNT_POINT_SMB ya está montado.${NC}" >&2
        return 0
    fi
    
    mkdir -p "$MOUNT_POINT_SMB"
    
    local PASS_DATA=""
    if ! PASS_DATA=$(pass show "$ACCESS_PASS_PATH_SMB" 2>/dev/null); then
        echo -e "${RED}❌ No se pudo obtener contraseña desde pass ($ACCESS_PASS_PATH_SMB).${NC}" >&2
        exit 1
    fi
    
    local SMB_PASS=""
    local SMB_USER=""
    SMB_PASS="$(printf "%s" "$PASS_DATA" | head -n1 | tr -d '\r')"
    SMB_USER="$(printf "%s" "$PASS_DATA" | sed -n 2p | tr -d '[:space:]\t')"
    if [[ "$SMB_USER" == user:* ]]; then
      SMB_USER="${SMB_USER#user:}"
    else
      echo "Error: Horror: user not found!!!"
      exit 1
    fi
    sudo mount -t cifs "$NAS_SHARE_SMB" "$MOUNT_POINT_SMB" \
        -o username=$SMB_USER,password="$SMB_PASS",uid=$(id -u),gid=$(id -g),noperm
        
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Montaje SMB exitoso.${NC}"
        create_symlink "$MOUNT_POINT_SMB" "$SYMLINK_SMB"
    else
        echo -e "${RED}❌ Fallo al montar SMB. Revisa las credenciales o permisos.${NC}"
    fi
}

mount_nfs_share() {
    echo -e "🔗 Montando NAS NFS en ${YELLOW}$MOUNT_POINT_NFS${NC}..." >&2
    
    if mountpoint -q "$MOUNT_POINT_NFS"; then
        echo -e "${YELLOW}⚠️ $MOUNT_POINT_NFS ya está montado.${NC}" >&2
        return 0
    fi
    
    mkdir -p "$MOUNT_POINT_NFS"
    
    sudo mount -t nfs "$NAS_SHARE_NFS" "$MOUNT_POINT_NFS"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Montaje NFS exitoso.${NC}"
        create_symlink "$MOUNT_POINT_NFS" "$SYMLINK_NFS"
    else
        echo -e "${RED}❌ Fallo al montar NFS. Revisa la configuración del servidor.${NC}"
    fi
}

# --- Funciones de Desmontaje ---
umount_smb_share() {
    echo -e "🔌 Desmontando SMB de ${YELLOW}$MOUNT_POINT_SMB${NC}..." >&2
    
    if ! mountpoint -q "$MOUNT_POINT_SMB"; then
        echo -e "${YELLOW}⚠️ $MOUNT_POINT_SMB no está montado.${NC}" >&2
        return 0
    fi
    
    sudo umount "$MOUNT_POINT_SMB"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Desmontaje SMB exitoso.${NC}"
        remove_symlink "$SYMLINK_SMB"
    else
        echo -e "${RED}❌ No se pudo desmontar $MOUNT_POINT_SMB.${NC}" >&2
        exit 1
    fi
}

umount_nfs_share() {
    echo -e "🔌 Desmontando NFS de ${YELLOW}$MOUNT_POINT_NFS${NC}..." >&2
    
    if ! mountpoint -q "$MOUNT_POINT_NFS"; then
        echo -e "${YELLOW}⚠️ $MOUNT_POINT_NFS no está montado.${NC}" >&2
        return 0
    fi
    
    sudo umount "$MOUNT_POINT_NFS"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Desmontaje NFS exitoso.${NC}"
        remove_symlink "$SYMLINK_NFS"
    else
        echo -e "${RED}❌ No se pudo desmontar $MOUNT_POINT_NFS.${NC}" >&2
        exit 1
    fi
}

# --- Lógica principal ---
case "$1" in
    up)
        case "$2" in
            smb)
                mount_smb_share
                ;;
            nfs)
                require_root
                mount_nfs_share
                ;;
            all)
                mount_smb_share
                mount_nfs_share
                ;;
            *)
                echo -e "${RED}❌ Tipo de share no especificado.${NC}" >&2
                show_help
                exit 1
                ;;
        esac
        ;;
    down)
        # require_root
        case "$2" in
            smb)
                umount_smb_share
                ;;
            nfs)
                umount_nfs_share
                ;;
            all)
                umount_smb_share
                umount_nfs_share
                ;;
            *)
                echo -e "${RED}❌ Tipo de share no especificado.${NC}" >&2
                show_help
                exit 1
                ;;
        esac
        ;;
    status)
        check_status
        ;;
    -h|--help)
        show_help
        ;;
    *)
        check_status
        exit 0
        ;;
esac
