#!/bin/bash

# Configuració
server_ip="10.0.2.16"  # Adreça IP del servidor NFS
nfs_directory="/var/nfs/empresa"  # Directori NFS a l'amfitrió
local_mount_point="/mnt/nfs-empresa"  # Punt de muntatge local

# Verifico si els paquets rpcbind i nfs-common estan instal·lats
if ! dpkg -l | grep -q rpcbind; then
    echo "Instal·lant el paquet rpcbind..."
    sudo apt-get install -y rpcbind
fi

if ! dpkg -l | grep -q nfs-common; then
    echo "Instal·lant el paquet nfs-common..."
    sudo apt-get install -y nfs-common
fi

# Creo el punt de muntatge local si no existeix
if [ ! -d "$local_mount_point" ]; then
    sudo mkdir -p "$local_mount_point"
    sudo chmod 777 "$local_mount_point"
fi

# Munto el directori NFS
sudo mount "$server_ip:$nfs_directory" "$local_mount_point"

# Afegeixo l'entrada a /etc/fstab per muntar automàticament el directori durant l'inici del sistema
echo "$server_ip:$nfs_directory $local_mount_point nfs defaults 0 0" | sudo tee -a /etc/fstab

# Verifico el muntatge correcte
if mountpoint -q "$local_mount_point"; then
    echo "El directori NFS s'ha muntat correctament a $local_mount_point."
else
    echo "No s'ha pogut muntar el directori NFS a $local_mount_point."
fi
