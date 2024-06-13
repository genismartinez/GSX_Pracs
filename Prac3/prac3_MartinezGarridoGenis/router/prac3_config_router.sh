#!/bin/bash

# Configurar el cliente DHCP para preferir nuestro servidor DNS y dominios
echo "prepend domain-name-servers 198.18.88.254;" >> /etc/dhcp/dhclient.conf
echo "supersede domain-name \"intranet.gsx dmz.gsx\";" >> /etc/dhcp/dhclient.conf

# Agregar una regla iptables para filtrar las consultas DNS salientes que no vienen de nuestro servidor
iptables -A FORWARD -i eth0 -p udp --dport 53 -s ! 198.18.88.254 -j DROP

# Aplicar una DNAT inversa para redirigir todas las consultas DNS entrantes a nuestro servidor DNS
iptables -t nat -A PREROUTING -i eth0 -p udp --dport 53 -j DNAT --to-destination 198.18.88.254

echo "Configuración del contenedor 'router' completada."
