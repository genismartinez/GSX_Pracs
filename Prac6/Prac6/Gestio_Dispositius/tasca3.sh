#!/bin/bash

verify_password() {
  echo "Introdueix la contrasenya: "
  stty -echo
  read -r password
  stty echo
  echo
  if [[ "$password" == "siusplau" ]]; then
    return 0
  else
    return 1
  fi
}

# Comprovem si la contrasenya és correcta
if verify_password; then
  /usr/bin/lp "$@"
  echo "Arxiu enviat a imprimir"
else
  # Mostrar missatge d'error si la contrasenya és incorrecta.
  echo "Contrasenya incorrecta. No es pot imprimir."
fi
