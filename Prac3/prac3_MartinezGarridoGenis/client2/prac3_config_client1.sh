#!/bin/bash

# Eliminar el contenido actual del archivo dhclient.conf
echo "" > /etc/dhcp/dhclient.conf

# Obtener el nombre del host de la máquina
HOSTNAME=$(hostname)

# Agregar las líneas requeridas al archivo dhclient.conf con el nombre de host dinámico
echo "send host-name = \"$HOSTNAME\";" >> /etc/dhcp/dhclient.conf
echo "send dhcp-lease-time 86400;" >> /etc/dhcp/dhclient.conf
echo "request domain-name, domain-name-servers, routers;" >> /etc/dhcp/dhclient.conf

ifdown eth0
ifup eth0

echo "Configuración completada en /etc/dhcp/dhclient.conf"

