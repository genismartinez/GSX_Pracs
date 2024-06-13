#!/bin/bash

# Configuració
local_mount_point="/mnt/nfs-empresa"  # Punt de muntatge local

# Desmunto el directori NFS
sudo umount "$local_mount_point"

# Comprovo si el desmuntatge ha estat exitós
if mountpoint -q "$local_mount_point"; then
    echo "No s'ha pogut desmuntar el directori NFS a $local_mount_point."
    exit 1
else
    echo "El directori NFS s'ha desmuntat correctament de $local_mount_point."
fi
