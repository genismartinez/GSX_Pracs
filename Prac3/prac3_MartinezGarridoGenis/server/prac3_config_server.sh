#!/bin/bash

# Modificar temporalmente el archivo /etc/resolv.conf con un nameserver genérico
echo "nameserver 1.1.1.1" > /etc/resolv.conf

# Instalar los paquetes necesarios
apt-get update
apt-get install -y bind9 bind9-doc dnsutils

# Configurar el forwarding de consultas desconocidas hacia el servidor DNS del ISP
sed -i 's/# forwarders {/forwarders {/' /etc/bind/named.conf.options
sed -i '/forwarders {/a \ \t1.1.1.1;' /etc/bind/named.conf.options

# Modificar la configuración de allow-recursion en named.conf.options
sed -i 's/#allow-recursion {/allow-recursion {/' /etc/bind/named.conf.options
sed -i '/allow-recursion {/a \ \t192.168.1.1; 198.18.88.255; 172.24.88.1; 172.24.88.254; 172.24.88.0\/23;' /etc/bind/named.conf.options

# Modificar el archivo /etc/default/named para atender solo peticiones IPv4
sed -i 's/OPTIONS="-u bind"/OPTIONS="-4 -u bind"/' /etc/default/named

# Agregar las configuraciones faltantes al archivo named.conf.options
echo "allow-transfer { localhost; };" >> /etc/bind/named.conf.options
echo "auth-nxdomain no;" >> /etc/bind/named.conf.options
echo "dnssec-validation no;" >> /etc/bind/named.conf.options
echo "listen-on-v6 { none; };" >> /etc/bind/named.conf.options

# Copiar los archivos de configuración a su ubicación final
cp -R /root/bind_configs/* /etc/bind/

# Cambiar las propiedades de los archivos
chmod --reference=/etc/bind /etc/bind/*
chown --reference=/etc/bind /etc/bind/*

# Iniciar el servicio y verificar el registro de eventos
systemctl start bind9
journalctl -u bind9

# Modificar el archivo /etc/resolv.conf
echo "nameserver 127.0.0.1" > /etc/resolv.conf
echo "search intranet.gsx dmz.gsx" >> /etc/resolv.conf

echo "Configuración del contenedor 'server' completada."
