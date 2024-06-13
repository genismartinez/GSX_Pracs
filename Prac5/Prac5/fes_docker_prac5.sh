#!/bin/bash

# Definim el nom de la imatge
IMAGE_NAME="gsx:prac5"

# Defineix opcions comunes per als comandos de docker run
OPCIONS="-itd --rm --privileged"

# Defineix el directori de pràctica5 a l'amfitrió per a la persistència de dades
HOST_PRACTICA5_DIR="./practica5"

# Crea el directori a l'amfitrió si no existeix
if [ ! -d "$HOST_PRACTICA5_DIR" ]; then
    mkdir -p "$HOST_PRACTICA5_DIR"
fi

# Funció per comprovar si un objecte docker s'ha creat correctament
check_object_existence() {
    local object_type="$1"
    local object_name="$2"
    local object_exists

    if [ "$object_type" = "network" ]; then
        object_exists=$(docker network ls --filter "name=${object_name}" --format "{{.Name}}")
    elif [ "$object_type" = "container" ]; then
        object_exists=$(docker container ls -a --filter "name=${object_name}" --format "{{.Names}}")
    fi

    if [ -z "$object_exists" ]; then
        echo "Error: L'objecte ${object_type} '${object_name}' no existeix."
        exit 1
    else
        echo "L'objecte ${object_type} '${object_name}' s'ha creat correctament."
    fi
}

# Construir la imatge
docker build -t "$IMAGE_NAME" -f dockerfile_gsx_prac5 .
if [ $? -ne 0 ]; then
    echo "Error: No s'ha pogut construir la imatge $IMAGE_NAME."
    exit 1
else
    echo "Imatge $IMAGE_NAME construïda correctament."
fi

# Crear xarxes ISP, DMZ, INTRANET
docker network create --driver=bridge --subnet=10.0.2.16/30 ISP
check_object_existence "network" "ISP"

docker network create --driver=bridge --subnet=198.18.88.224/27 DMZ
check_object_existence "network" "DMZ"

docker network create --driver=bridge --subnet=172.24.88.0/23 INTRANET
check_object_existence "network" "INTRANET"

# Executar contenidors
# Contenidor Router
docker run $OPCIONS --hostname router --network=ISP --name Router "$IMAGE_NAME"
check_object_existence "container" "Router"

# Contenidor Server
docker run $OPCIONS --hostname server --network=DMZ --name Server --mount type=bind,src="$HOST_PRACTICA5_DIR",dst=/root/prac5 "$IMAGE_NAME"
check_object_existence "container" "Server"

# Contenidor Intranet
docker run $OPCIONS --hostname intranet --network=INTRANET --name Intranet "$IMAGE_NAME"
check_object_existence "container" "Intranet"

echo "Script fes_docker_prac5.sh finalitzat amb èxit."
