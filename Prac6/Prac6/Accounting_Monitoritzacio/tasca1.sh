#!/bin/bash

# Verificar si s'executa amb permisos de superusuari
if [ "$EUID" -ne 0 ]; then
  echo "Si us plau, executa aquest script com a superusuari (sudo)."
  exit 1
fi

# Comprovar que s'ha passat almenys una comanda com a paràmetre
if [ $# -lt 1 ]; then
  echo "Ús: $0 <comanda> [<usuari>]"
  exit 1
fi

COMANDA=$1
USUARI=$2

# Funció per trobar dies que l'usuari ha executat la comanda
comanda_per_usuari() {
  local user=$1
  local cmd=$2
  echo "Comanda: $cmd, Usuari: $user" # Debug
  local result=$(lastcomm $cmd | grep " $user ")

  if [ -z "$result" ]; then
    echo "L'usuari $user no ha executat la comanda $cmd."
  else
    echo "Dies que l'usuari $user ha executat la comanda $cmd:"
    echo "$result" | awk '{print $6, $7, $8, $9, $10, $11, $12, $13}'
  fi
}

# Funció per trobar usuaris que han executat la comanda i el nombre de vegades
comanda_general() {
  local cmd=$1
  echo "Comanda: $cmd" # Debug
  echo "Usuaris que han executat la comanda $cmd i el nombre de vegades:"
  lastcomm $cmd | awk '{print $1, $2}' | sort | uniq -c | sort -nr
}

# Comprovar si s'ha proporcionat un usuari
if [ -n "$USUARI" ]; then
  comanda_per_usuari "$USUARI" "$COMANDA"
else
  comanda_general "$COMANDA"
fi

