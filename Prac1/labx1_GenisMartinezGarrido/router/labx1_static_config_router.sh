#!/bin/bash

# A) Configuració de la interfície ethernet eth1 amb iproute2
# Obtenim la primera adreça disponible del rang assignable
ip address add 198.18.88.225/27 broadcast 198.18.88.255 dev eth1
ip link set eth1 up

# B) Activació del ipv4 forwarding de forma permanent
sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/" /etc/sysctl.conf
sysctl -p

# C) Configuració del fitxer /etc/hosts per al router
# Eliminem qualsevol entrada anterior per al servidor

if [[ -z $(cat /etc/hosts | grep 198.18.88.254) ]]; then
        echo "198.18.88.254     server">>/etc/hosts
fi

# D) Configuració de SNAT per a l'accés a Internet des del router
# Cal canviar les IPs font privades per la IP externa del router
if ! iptables -t nat -C POSTROUTING - s 198.18.88.224/27 -o eth0 -j MASQUERADE &> /dev/null; then
        iptables -t nat -A POSTROUTING -s 198.18.88.224/27 -o eth0 -j MASQUERADE
fi

# E) Habilitació del servei SSH
# Comprovem si el paquet openssh-server està instal·lat
if ! dpkg -s openssh-server >/dev/null 2>&1; then
        apt install -y openssh-server
        systemctl status ssh
        ss -4lnt | grep ":22 "
fi

# Habilitació de l'accés remot per a l'usuari root
sed -i "s/#PermitRootLogin/PermitRootLogin/g" /etc/ssh/sshd_config
sed -i "s/PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config

# Reiniciem el servei SSH per aplicar els canvis
systemctl restart ssh
