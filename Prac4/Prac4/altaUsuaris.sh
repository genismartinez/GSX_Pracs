#!/bin/bash

# Crea els directoris necessaris
mkdir -p /empresa/projectes
mkdir -p /empresa/bin
mkdir -p /empresa/usuaris

if [ $# -ne 2 ]; then
	echo "Introdueix els fitxers"
	exit 
else
	# Llegim les dades del fitxer d'usuaris
    while IFS=':' read -r dni nom tel grups; do 
        # Separem els grups en un array
        IFS=',' read -ra arr_grups <<< "$grups"
        for dep in "${arr_grups[@]}"; do
            # Creem el grup si no existeix
            groupadd "$dep" 2>/dev/null
            # Afegim l'usuari al grup i creem el directori de l'usuari
            useradd -m -d "/empresa/usuaris/$dep/$dni" -s /bin/bash -G "$dep" "$dni" 2>/dev/null
            # Canviem la contrasenya de l'usuari
            echo "${dni}:${dni}" | chpasswd
            # Creem el directori bin de l'usuari si no existeix
            mkdir -p -m 700 "/empresa/usuaris/$dep/$dni/bin" 2>/dev/null 
            user_dir="/empresa/usuaris/$dep/$dni"
            if [ ! -f "$user_dir/.bashrc" ]; then
                # Afegim el directori bin de l'usuari al final de la variable PATH 
                echo "export PATH=\$PATH:$user_dir/bin:$(pwd)" >> "$user_dir/.bashrc"
            fi 
        done
    done < "$1"

	# Llegim les dades del fitxer de projectes
	while IFS=':' read -r proj cap descripcio; do 
		# Obtenim el grup de l'usuari
		group=$(groups $cap | awk '{print $NF}') 
		# Creem el directori del projecte
		mkdir -p /empresa/projectes/$proj 
		# Assignem l'usuari com a propietari del directori
		chown $cap /empresa/projectes/$proj 
		# Assignem el grup del projecte al directori
		chgrp $group /empresa/projectes/$proj 
		# Mostrem el grup
		echo "$group"
	done < "$2"

# Donem permisos als directoris binaris
chmod 751 /empresa/bin
# Activem el bit sticky al directori binari
chmod +t /empresa/bin

fi
