#!/bin/bash

# Verificar permisos de sudo
if [[ $EUID -ne 0 ]]; then
   echo "Aquest script necessita ser executat amb privilegis de sudo."
   exit 1
fi

echo "Es necessita la contrasenya per configurar els enllaços de xarxa. Si us plau, introdueix la contrasenya quan es demani."
read -p "Prem Enter per continuar..."

# Contenidors a verificar
containers=("R1" "R2" "R3" "R4")

# Assegurar que els contenidors estan en execució
for container in "${containers[@]}"; do
    status=$(docker inspect --format '{{.State.Status}}' $container)
    if [ "$status" != "running" ]; then
        echo "El contenidor $container NO està en execució. Estat: $status"
        echo "Arrencant el contenidor $container..."
        docker start $container
        sleep 2  # Esperar uns segons per assegurar que el contenidor està arrencat
    fi
done

# Crear enllaços
echo "Creant enllaços..."
ip link add link1_veth1 type veth peer name link1_veth2
ip link add link2_veth1 type veth peer name link2_veth2
ip link add link3_veth1 type veth peer name link3_veth2
ip link add link4_veth1 type veth peer name link4_veth2

echo "Enllaços creats."

# Assignar enllaços als contenidors
echo "Assignant enllaços als contenidors..."

# Obtenir PIDs dels contenidors
pid_R1=$(docker inspect --format '{{.State.Pid}}' R1)
pid_R2=$(docker inspect --format '{{.State.Pid}}' R2)
pid_R3=$(docker inspect --format '{{.State.Pid}}' R3)
pid_R4=$(docker inspect --format '{{.State.Pid}}' R4)

# Assignar enllaços als contenidors corresponents
ip link set link1_veth1 netns $pid_R1
ip link set link1_veth2 netns $pid_R2
ip link set link2_veth1 netns $pid_R2
ip link set link2_veth2 netns $pid_R3
ip link set link3_veth1 netns $pid_R3
ip link set link3_veth2 netns $pid_R4
ip link set link4_veth1 netns $pid_R4
ip link set link4_veth2 netns $pid_R1

echo "Enllaços assignats."

# Assignar adreces IP i activar interfícies dins dels contenidors
echo "Assignant adreces IP i activant interfícies..."

nsenter -t $pid_R1 -n ip addr add 10.88.1.1/30 dev link1_veth1
nsenter -t $pid_R1 -n ip link set dev link1_veth1 up
nsenter -t $pid_R2 -n ip addr add 10.88.1.2/30 dev link1_veth2
nsenter -t $pid_R2 -n ip link set dev link1_veth2 up

nsenter -t $pid_R2 -n ip addr add 10.88.2.1/30 dev link2_veth1
nsenter -t $pid_R2 -n ip link set dev link2_veth1 up
nsenter -t $pid_R3 -n ip addr add 10.88.2.2/30 dev link2_veth2
nsenter -t $pid_R3 -n ip link set dev link2_veth2 up

nsenter -t $pid_R3 -n ip addr add 10.88.3.1/30 dev link3_veth1
nsenter -t $pid_R3 -n ip link set dev link3_veth1 up
nsenter -t $pid_R4 -n ip addr add 10.88.3.2/30 dev link3_veth2
nsenter -t $pid_R4 -n ip link set dev link3_veth2 up

nsenter -t $pid_R4 -n ip addr add 10.88.4.1/30 dev link4_veth1
nsenter -t $pid_R4 -n ip link set dev link4_veth1 up
nsenter -t $pid_R1 -n ip addr add 10.88.4.2/30 dev link4_veth2
nsenter -t $pid_R1 -n ip link set dev link4_veth2 up

echo "Adreces IP assignades i interfícies activades."

echo "Configuració completada."
