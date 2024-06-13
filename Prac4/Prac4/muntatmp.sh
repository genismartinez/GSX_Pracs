#!/bin/bash

# Defineixo el directori de treball temporal sota el directori de l'usuari
temp_dir="$HOME/tmp"

# Defineixo la mida del sistema de fitxers tmpfs
tmpfs_size="100M"

# Verifico si el directori temporal existeix, si no, crea'l
if [ ! -d "$temp_dir" ]; then
    mkdir -p "$temp_dir"
    # Opcional: Ajusta els permisos del directori si cal
    chmod 700 "$temp_dir"
fi

# Munto el sistema de fitxers tmpfs sota el directori de treball temporal de l'usuari
sudo mount -t tmpfs -o size=$tmpfs_size tmpfs "$temp_dir"

# Afegeixo una entrada al fitxer /etc/fstab per muntar automàticament el sistema# de fitxers tmpfs en cada inici del sistema
echo "tmpfs $temp_dir tmpfs size=$tmpfs_size,rw,nodev,nosuid,noexec 0 0" | sudo tee -a /etc/fstab

# Muntatge automàtic del sistema de fitxers en cada inici de sessió

# Afegeixo la línia següent als fitxers d'inici de sessió de l'usuari
# perquè l'script muntatmp.sh s'executi cada vegada que l'usuari entri al sistema
echo "/home/milax/Escriptori/GSX_Labs/Prac4/muntatmp.sh" >> "$HOME/.bashrc"
