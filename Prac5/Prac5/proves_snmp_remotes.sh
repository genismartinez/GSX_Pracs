#!/bin/bash

# L'adreça IP del contenidor remot es passa com a primer paràmetre al script
CONTENIDOR_REMOT_IP=$1

# Comandes SNMP locals adaptades per a ser remotes, usant el paràmetre d'accés USM
# Accedir als MIBs de la Univ. California Davis
echo "Proves SNMP remotes"

# Accedir al sistema
snmpwalk -v 2c -c public "$CONTENIDOR_REMOT_IP" system
# Accedir al sistema de recursos humans
snmpwalk -v 2c -c public "$CONTENIDOR_REMOT_IP" hrSystem
# Taula de processos
snmptable -v 2c -c cilbup "$CONTENIDOR_REMOT_IP" UCD-SNMP-MIB::prTable
# Taula d'ús de disco
snmptable -v 2c -c cilbup "$CONTENIDOR_REMOT_IP" ucdavis.dskTable
# Taula de càrrega
snmptable -v 2c -c cilbup "$CONTENIDOR_REMOT_IP" ucdavis.laTable
