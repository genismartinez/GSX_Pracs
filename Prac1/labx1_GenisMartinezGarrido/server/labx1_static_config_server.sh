#!/bin/bash

# A) Configuració de la interfície ethernet eth0 amb ifupdown
# Obtenim l'última adreça disponible del rang assignable
# Escrivim la configuració de la interfície eth0 al fitxer /etc/network/interfaces

count=$(ifquery eth0 | grep -c 198.18.88.254)
echo $count
if [ $count -eq 0 ]; then
    sed -i "s/eth0 inet dhcp/eth0 inet static/" /etc/network/interfaces
    echo "    address   198.18.88.254" >> /etc/network/interfaces
    echo "    network   198.18.88.224" >> /etc/network/interfaces
    echo "    gateway   198.18.88.225" >> /etc/network/interfaces
    echo "    broadcast   198.18.88.255" >> /etc/network/interfaces
    echo "    netmask   255.255.255.224" >> /etc/network/interfaces

    # Aplicació de la nova configuració de la interfície eth0
    ifdown eth0 && ifup eth0
fi    
    
# Afegeix la nova entrada si no existeix
   
if [[ -z $(cat /etc/hosts | grep 198.18.88.225) ]]; then
        echo "198.18.88.225     router">>/etc/hosts
fi
      
echo "Fet"

if ! dpkg -s openssh-server >/dev/null 2>&1; then
        sudo apt install -y openssh-server
        sudo systemctl status ssh
        ss -4lnt | grep ":22 "
fi  
    
sed -i "s/#PermitRootLogin/PermitRootLogin/g" /etc/ssh/sshd_config
sed -i "s/PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
systemctl restart ssh
