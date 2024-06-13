#!/bin/bash

# Comprovar si s'està executant com a superusuari
if [ "$(id -u)" -ne 0 ]; then
    echo "Aquest script s'ha d'executar com a superusuari."
    exit 1
fi

# Desactivar i eliminar arxiu de swap existent
if swapon -s | grep -q '/var/swap'; then
    swapoff /var/swap
    rm -f /var/swap
fi

# Crear arxiu de swap
dd if=/dev/zero of=/var/swap bs=4096k count=16

# Comprovar si la creació ha estat exitosa
if [ $? -ne 0 ]; then
    echo "Error en crear l'arxiu de swap."
    exit 1
fi

# Canviar els permisos de l'arxiu de swap
chmod 0600 /var/swap

tam_swap=$(du -h /var/swap | awk '{print $1}')
mkswap /var/swap
echo "S'ha creat un arxiu de swap amb la mida: $tam_swap"

swapon /var/swap

swap_total=$(free -h | awk '/^Swap/ {print $2}')
swap_usat=$(free -h | awk '/^Swap/ {print $3}')
swap_disponible=$(free -h | awk '/^Swap/ {print $4}')
echo "S'ha afegit l'arxiu de swap al swap existent."
echo "Mida total del swap: $swap_total"
echo "Swap utilitzat: $swap_usat"
echo "Swap disponible: $swap_disponible"

# Muntar un fitxer .img per accedir a la seva informació
arxiu_img="memtest86-usb.img"
directori_munt="/mnt"

# Comprovar si el fitxer existeix
if [ ! -f "$arxiu_img" ]; then
    echo "L'arxiu $arxiu_img no existeix."
    exit 1
fi

# Comprovar si el mòdul loop està carregat
if ! lsmod | grep -q "^loop"; then
    echo "El mòdul loop no està carregat. Carregant el mòdul loop."
    modprobe loop
fi

# Muntar memtest86-usb.img
mount -o loop "$arxiu_img" "$directori_munt"

# Comprovar si el muntatge ha estat exitós
if [ $? -ne 0 ]; then
    echo "Error en muntar l'arxiu d'imatge."
    exit 1
fi

# Mostra els mòduls carregats després del muntatge
moduls_abans=$(lsmod)
moduls_despres=$(lsmod | grep -v "$moduls_abans")

echo "S'han instal·lat els següents mòduls:"
echo "$moduls_despres"

