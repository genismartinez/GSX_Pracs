#!/bin/bash

# Autor (Genís Martínez Garrido - GSX)

date=$(date +"%Y-%m-%d %H:%M:%S")
if [ $# -gt 0 ]; then
    # Iterem sobre cada argument
    for paquet in "$@"
    do
        # Comprovo si el paquet ja està instal·lat
        if apt list --installed 2>&1 | grep -w "$paquet" >/dev/null 2>&1; then
            echo "Informació del paquet $paquet:"
            # Versió actualment instal·lada
            installed_version=$(dpkg -l | grep -w "$paquet" | awk '{print $3}')
            echo "Versió actualment instal·lada: $installed_version"
            
            # Data i hora d'instal·lació
            install_date=$(stat -c %y /var/lib/dpkg/info/"$paquet".list)
            echo "Data i hora d'instal·lació: $install_date"
            
            # Disponibilitat d'actualització
            update_info=$(apt list --upgradable 2>&1 | grep -w "$paquet" | awk -F/ '{print $1}')
            if [ -n "$update_info" ]; then
                echo "Disponibilitat d'actualització: Hi ha una nova versió disponible"
            else
                echo "Disponibilitat d'actualització: No hi ha cap nova versió disponible"
            fi
            
            # Llista de dependències del paquet
            dependencies=$(apt-cache depends "$paquet" | grep "Depends" | awk '{print $2}')
            echo "Llista de dependències del paquet:"
            echo "$dependencies"
            
            # Fitxers de configuració associats amb el paquet
            config_files=$(dpkg -L "$paquet")
            echo "Fitxers de configuració associats amb el paquet:"
            echo "$config_files"
        else
            # Si no està instal·lat, mostro per pantalla que no està instal·lat
            echo "$date $paquet no està instal·lat."
        fi
    done
else
    echo "No s'ha passat cap argument com a paràmetre."
    exit 0
fi

