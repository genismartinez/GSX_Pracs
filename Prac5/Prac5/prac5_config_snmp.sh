#!/bin/bash

# Actualitzar/instal·lar paquets
apt update
apt install rsyslog snmp snmpd smistrip patch snmp-mibs-downloader -y

# Crear directori local i els arxius de configuració
mkdir -p /root/router
cp /etc/snmp/snmpd.conf /root/router/snmpd.conf
cp /etc/snmp/snmp.conf /root/router/snmp.conf
mkdir -p /root/server
cp /etc/snmp/snmpd.conf /root/server/snmpd.conf
cp /etc/snmp/snmp.conf /root/server/snmp.conf

#touch /root/router/snmp.conf
#touch /root/router/snmpd.conf

# Configurar snmp.conf
echo "mibdirs + /usr/share/mibs" > /root/router/snmp.conf
echo "mibs +ALL" >> /root/router/snmp.conf
echo "mibdirs + /usr/share/mibs" > /root/server/snmp.conf
echo "mibs +ALL" >> /root/server/snmp.conf

sed -i 's/.*mibs :.*/#mibs :/' /root/$HOSTNAME/snmp.conf

sed -i 's/agentaddress .*/agentaddress    udp:161/' /root/$HOSTNAME/snmpd.conf
sed -i 's/sysLocation .*/sysLocation    Sitges/' /root/$HOSTNAME/snmpd.conf
sed -i 's/sysContact .*/sysContact    Genís Martínez Garrido/' /root/$HOSTNAME/snmpd.conf

OIDIF=$(snmptranslate -On IF-MIB::interfaces)

OIDIP=$(snmptranslate -On IP-MIB::ip)

OIDICMP=$(snmptranslate -On IP-MIB::icmp)

OIDUCD=$(snmptranslate -On UCD-SNMP-MIB::ucdavis)

OIDSNMP=$(snmptranslate -On SNMPv2-MIB::snmp)
echo "--------------BEGIN----------------"
echo $OIDIF
echo $OIDIP
echo $OIDICMP
echo $OIDUCD
echo $OIDSNMP
if [[ -z $(cat /etc/snmp/snmpd.conf | grep "vistagsx included") ]]; then
	echo "---------------DONE---------------"
	sed -i 's/view   systemonly  included   .1.3.6.1.2.1.25.1/view   systemonly  included   .1.3.6.1.2.1.25.1\
	\nview   vistagsx  included   '"$OIDIF"\
	'\nview   vistagsx  included   '"$OIDIP"\
	'\nview   vistagsx  included   '"$OIDICMP"\
	'\nview   vistagsx  included   '"$OIDUCD"\
	'\nview   vistagsx  included   '"$OIDSNMP"'/' /root/$HOSTNAME/snmpd.conf
fi

# Defineixo les vistes per a `vistagsx` (interfaces, ip, snmp, icmp, ucdavis)
echo "view vistagsx included $OIDIF $OIDIP $OIDSNMP $OIDICMP $OIDUCD" >> /root/$HOSTNAME/snmpd.conf


# Configuració per a l'accés read-only a la vista especificada des del localhost
if [[ -z $(grep "cilbup localhost" /etc/snmp/snmpd.conf) ]]; then
    echo "rocommunity cilbup localhost -V vistagsx" >> /root/$HOSTNAME/snmpd.conf
fi

if [[ -z $(cat /etc/snmp/snmpd.conf | grep "49500088V") ]]; then

	sed -i 's/rocommunity6 public default -V systemonly/rocommunity6 public default -V systemonly\
	rocommunity 49500088V 203.0.113.0\/25 -V vistagsx/' /root/$HOSTNAME/snmpd.conf
fi

if [ -z "$(cat /root/$HOSTNAME/snmpd.conf | grep 'gsxViewer SHA-512')" ] ; then
    echo "createUser gsxViewer SHA-512 \"autV88000594\"" >> /root/$HOSTNAME/snmpd.conf
    echo "createUser gsxAdmin SHA-512 \"autV88000594\" DES \"secV88000594\"" >> /root/$HOSTNAME/snmpd.conf
    echo "rouser gsxViewer auth SHA-512 \"autV88000594\"" >> /root/$HOSTNAME/snmpd.conf
    echo "rwuser gsxAdmin authPriv SHA-512 \"autV88000594\" DES \"secV88000594\"" >> /root/$HOSTNAME/snmpd.conf
fi

cp -p /root/$HOSTNAME/snmpd.conf /etc/snmp/snmpd.conf
cp -p /root/$HOSTNAME/snmp.conf /etc/snmp/snmp.conf
chmod 644 /etc/snmp/snmp.conf
chmod 600 /etc/snmp/snmpd.conf
