#!/bin/bash

# Construir la imatge Docker
echo "Construint la imatge Docker..."
docker build -t gsx:prac7 -f dockerfile_gsx_prac7 .
if [ $? -ne 0 ]; then
    echo "Error en construir la imatge Docker."
    exit 1
fi

# Crear el contenidor R1 amb network bridge
echo "Creant el contenidor R1..."
docker run -itd --rm --privileged --hostname router1 --name R1 gsx:prac7
if [ $? -ne 0 ]; then
    echo "Error en crear el contenidor R1."
    exit 1
fi

# Crear els altres contenidors sense networks
echo "Creant els altres contenidors..."
for node in 2 3 4; do
    docker run -itd --rm --privileged --hostname router$node --network=none --name R$node gsx:prac7
    if [ $? -ne 0 ]; then
        echo "Error en crear el contenidor R$node."
        exit 1
    fi
done

# Donar temps als contenidors per iniciar-se
sleep 5

# Verificar els contenidors
echo "Verificant contenidors..."

for node in 1 2 3 4; do
    echo "Verificant contenidor R$node..."
    status=$(docker inspect --format '{{.State.Status}}' R$node)
    if [ "$status" == "running" ]; then
        echo "El contenidor R$node està en execució."
    else
        echo "El contenidor R$node NO està en execució. Estat: $status"
        echo "Logs del contenidor R$node:"
        docker logs R$node
        exit 1
    fi
done

# Avisar a l'usuari que es necessita la contrasenya per configurar els enllaços
echo "Es necessita la contrasenya per configurar els enllaços de xarxa. Si us plau, introdueix la contrasenya quan es demani."
read -p "Prem Enter per continuar..." dummy

# Executar l'script configurar_enllaços.sh amb sudo
echo "Executant l'script crea_enllaços.sh amb sudo..."
sudo ./crea_enllaços.sh
if [ $? -ne 0 ]; then
    echo "Error en executar l'script crea_enllaços.sh."
    exit 1
fi

echo "Configuració completada amb èxit."
