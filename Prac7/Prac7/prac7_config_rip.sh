#!/bin/bash

# Configuració del servei zebra
touch /etc/quagga/zebra.conf

# Ajustar permissos
chown -R quagga.quaggavty /etc/quagga/
chmod 640 /etc/quagga/*.conf

# Configuració de mascarada en R1 (només si el hostname és router1)
if [ "$(hostname)" == "router1" ]; then
    # Configuració del servei ripd
    cat <<EOF > /etc/quagga/ripd.conf
router rip
   version 2
   network 10.88.1.2/30
   network 10.88.4.1/30
   default-information originate
   passive-interface eth0
EOF

    apt-get update
    apt-get install -y iptables

    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
fi

if [ "$(hostname)" == "router2" ]; then
    # Configuració del servei ripd
    cat <<EOF > /etc/quagga/ripd.conf
router rip
   version 2
   network 10.88.1.2/30
   network 10.88.2.1/30
EOF
fi

if [ "$(hostname)" == "router3" ]; then
    # Configuració del servei ripd
    cat <<EOF > /etc/quagga/ripd.conf
router rip
   version 2
   network 10.88.2.1/30
   network 10.88.3.2/30
EOF
fi

if [ "$(hostname)" == "router4" ]; then
    # Configuració del servei ripd
    cat <<EOF > /etc/quagga/ripd.conf
router rip
   version 2
   network 10.88.3.2/30
   network 10.88.4.1/30
EOF
fi

service zebra restart
service ripd restart
