#!/bin/bash

# Eliminar el contenido actual del archivo resolv.conf
echo "" > /etc/resolv.conf

# Agregar las líneas requeridas al archivo resolv.conf
echo "nameserver 198.18.88.254" >> /etc/resolv.conf
echo "search intranet.gsx dmz.gsx" >> /etc/resolv.conf

echo "Configuración completada en /etc/resolv.conf del servidor DHCP"
