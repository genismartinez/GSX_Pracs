#!/bin/bash

apt update
apt install snmp snmp-mibs-downloader -y

# OIDs que volem monitoritzar
OID_SET_REQUESTS="SNMPv2-MIB::snmpInSetRequests.0"
OID_GET_REQUESTS="SNMPv2-MIB::snmpInGetRequests.0"

# Llindar per als increments
LLINDAR=5  # He definit arbitrariament el llindar a 5

# Directori per emmagatzemar els últims valors dels OIDs
STATE_DIR="/root/snmp_state"

# Creo el directori d'estat si no existeix
mkdir -p "$STATE_DIR"

# Funció per consultar els OIDs utilitzant snmpget
consultar_oid() {
  local oid=$1
  snmpget -v2c -c public localhost "$oid" | awk '{print $4}'
}

# Funció per guardar els valors d'un OID
guardar_valor() {
  local oid=$1
  local valor=$2
  local fitxer_estat="$STATE_DIR/$(echo "$oid" | tr ':' '_').txt"
  echo "$valor" > "$fitxer_estat"
}

# Funció per obtenir els valors d'un OID desats anteriorment
obtenir_valor_previ() {
  local oid=$1
  local fitxer_estat="$STATE_DIR/$(echo "$oid" | tr ':' '_').txt"
  if [ -f "$fitxer_estat" ]; then
    cat "$fitxer_estat"
  else
    echo "0"  # Valor per defecte si no hi ha un valor previ
  fi
}

# Consulta els OIDs actuals
set_requests_actual=$(consultar_oid "$OID_SET_REQUESTS")
get_requests_actual=$(consultar_oid "$OID_GET_REQUESTS")

# Obté els valors previs
set_requests_previ=$(obtenir_valor_previ "$OID_SET_REQUESTS")
get_requests_previ=$(obtenir_valor_previ "$OID_GET_REQUESTS")

# Calcula els increments
increment_set_requests=$((set_requests_actual - set_requests_previ))
increment_get_requests=$((get_requests_actual - get_requests_previ))

# Si l'increment de set_requests és major que zero, genera un avís
if [ $increment_set_requests -gt 0 ]; then
    logger -p user.warning -t GSX "AVÍS: L'increment de $OID_SET_REQUESTS ha augmentat massa: $increment_set_requests"
fi

# Si l'increment de get_requests supera el llindar, genera un avís
if [ $increment_get_requests -gt $LLINDAR ]; then
    logger -p user.warning -t GSX "AVÍS: L'increment de $OID_GET_REQUESTS ha augmentat massa: $increment_get_requests"
fi

# Guarda els valors actuals per a la propera execució
guardar_valor "$OID_SET_REQUESTS" "$set_requests_actual"
guardar_valor "$OID_GET_REQUESTS" "$get_requests_actual"

