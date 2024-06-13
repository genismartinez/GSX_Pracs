#!/bin/bash

# Author (Genís Martínez Garrido - GSX)

# Verificar que s'ha proporcionat almenys un argument
if [ $# -eq 0 ]; then
    echo "Mode d'ús: $0 <package_name>"
    exit 1
fi

package_name="$1"

# Comprovar si el paquet està instal·lat
if dpkg -l | grep -q "^ii.*$package_name "; then
    # Desinstal·lar el paquet
    apt-get remove "$package_name"
    # Comprovar si s'ha produït algun error durant l'execució de apt-get remove
    if [ $? -eq 0 ]; then
        echo "El paquet $package_name s'ha desinstal·lat amb èxit."
    else
        echo "S'ha produït un error durant la desinstal·lació del paquet $package_name."
        exit 1
    fi
else
    echo "El paquet $package_name no està instal·lat."
    exit 1
fi

