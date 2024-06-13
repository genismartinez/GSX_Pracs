#!/bin/bash

# Fitxer de sortida
OUTPUT_FILE="sortida_prac7.txt"
echo "" > $OUTPUT_FILE

echo "Iniciant proves..." | tee -a $OUTPUT_FILE
echo "===================" | tee -a $OUTPUT_FILE

# Comprovem que els daemons s'estan executant
echo "Comprovem que els daemons s'estan executant..." | tee -a $OUTPUT_FILE
echo "---------------------------------------------" | tee -a $OUTPUT_FILE
docker top R2 | tee -a $OUTPUT_FILE
docker top R3 | tee -a $OUTPUT_FILE
docker top R4 | tee -a $OUTPUT_FILE
echo "" | tee -a $OUTPUT_FILE

# Comprovem la taula d'encaminament
echo "Comprovant la taula d'encaminament..." | tee -a $OUTPUT_FILE
echo "------------------------------------" | tee -a $OUTPUT_FILE
docker exec R1 ip -c route | tee -a $OUTPUT_FILE
echo "------------------------------------" | tee -a $OUTPUT_FILE
docker exec R2 ip -c route | tee -a $OUTPUT_FILE
echo "------------------------------------" | tee -a $OUTPUT_FILE
docker exec R3 ip -c route | tee -a $OUTPUT_FILE
echo "------------------------------------" | tee -a $OUTPUT_FILE
docker exec R4 ip -c route | tee -a $OUTPUT_FILE
echo "" | tee -a $OUTPUT_FILE

# Comprovem la configuració i la taula d'encaminament amb vtysh
echo "Comprovant la configuració i la taula d'encaminament amb vtysh..." | tee -a $OUTPUT_FILE
echo "-----------------------------------------------------------------" | tee -a $OUTPUT_FILE
docker exec -i R1 sh -c 'vtysh -c "show running-config" -c "show ip route" -c "show ip rip status"' | tee -a $OUTPUT_FILE
echo "-----------------------------------------------------------------" | tee -a $OUTPUT_FILE
docker exec -i R2 sh -c 'vtysh -c "show running-config" -c "show ip route" -c "show ip rip status"' | tee -a $OUTPUT_FILE
echo "-----------------------------------------------------------------" | tee -a $OUTPUT_FILE
docker exec -i R3 sh -c 'vtysh -c "show running-config" -c "show ip route" -c "show ip rip status"' | tee -a $OUTPUT_FILE
echo "-----------------------------------------------------------------" | tee -a $OUTPUT_FILE
docker exec -i R4 sh -c 'vtysh -c "show running-config" -c "show ip route" -c "show ip rip status"' | tee -a $OUTPUT_FILE
echo "" | tee -a $OUTPUT_FILE

# Comprovem les IPs i les rutes
echo "Comprovant les IPs i les rutes..." | tee -a $OUTPUT_FILE
echo "--------------------------------" | tee -a $OUTPUT_FILE
docker exec R1 ip -c address | tee -a $OUTPUT_FILE
echo "--------------------------------" | tee -a $OUTPUT_FILE
docker exec R2 ip -c address | tee -a $OUTPUT_FILE
echo "--------------------------------" | tee -a $OUTPUT_FILE
docker exec R3 ip -c address | tee -a $OUTPUT_FILE
echo "--------------------------------" | tee -a $OUTPUT_FILE
docker exec R4 ip -c address | tee -a $OUTPUT_FILE
echo "" | tee -a $OUTPUT_FILE

# Comprovem la connectivitat cap a diverses IPs des de R1
echo "Comprovant connectivitat cap a 10.88.3.2 des de R1..." | tee -a $OUTPUT_FILE
echo "----------------------------------------------------" | tee -a $OUTPUT_FILE
docker exec R1 ping -c1 10.88.3.2 | tee -a $OUTPUT_FILE
docker exec R1 traceroute -n 10.88.3.2 | tee -a $OUTPUT_FILE
docker exec R1 traceroute -n -T 10.88.3.2 | tee -a $OUTPUT_FILE
echo "" | tee -a $OUTPUT_FILE

echo "Comprovant connectivitat cap a 10.88.4.2 des de R2..." | tee -a $OUTPUT_FILE
echo "----------------------------------------------------" | tee -a $OUTPUT_FILE
docker exec R2 ping -c1 10.88.4.2 | tee -a $OUTPUT_FILE
docker exec R2 traceroute -n 10.88.4.2 | tee -a $OUTPUT_FILE
docker exec R2 traceroute -n -T 10.88.4.2 | tee -a $OUTPUT_FILE
echo "" | tee -a $OUTPUT_FILE

echo "Comprovant connectivitat cap a 10.88.1.2 des de R3..." | tee -a $OUTPUT_FILE
echo "----------------------------------------------------" | tee -a $OUTPUT_FILE
docker exec R3 ping -c1 10.88.1.2 | tee -a $OUTPUT_FILE
docker exec R3 traceroute -n 10.88.1.2 | tee -a $OUTPUT_FILE
docker exec R3 traceroute -n -T 10.88.1.2 | tee -a $OUTPUT_FILE
echo "" | tee -a $OUTPUT_FILE

echo "Comprovant connectivitat cap a 10.88.2.1 des de R4..." | tee -a $OUTPUT_FILE
echo "----------------------------------------------------" | tee -a $OUTPUT_FILE
docker exec R4 ping -c1 10.88.2.1 | tee -a $OUTPUT_FILE
docker exec R4 traceroute -n 10.88.2.1 | tee -a $OUTPUT_FILE
docker exec R4 traceroute -n -T 10.88.2.1 | tee -a $OUTPUT_FILE
echo "" | tee -a $OUTPUT_FILE

# Baixem la interfície link1_veth2 al R2 i comprovem la nova ruta
echo "Baixem la interfície link1_veth2 al R2..." | tee -a $OUTPUT_FILE
echo "----------------------------------------" | tee -a $OUTPUT_FILE
docker exec R2 ip link set dev link1_veth2 down | tee -a $OUTPUT_FILE
docker exec R1 ip route get 10.88.3.2 | tee -a $OUTPUT_FILE
echo "" | tee -a $OUTPUT_FILE

echo "Comprovant la nova ruta després de la caiguda al R2..." | tee -a $OUTPUT_FILE
echo "----------------------------------------------------" | tee -a $OUTPUT_FILE
docker exec R1 traceroute -n 10.88.2.2 | tee -a $OUTPUT_FILE
docker exec R4 traceroute -n 10.88.2.1 | tee -a $OUTPUT_FILE
echo "" | tee -a $OUTPUT_FILE

echo "Proves completades." | tee -a $OUTPUT_FILE
echo "===================" | tee -a $OUTPUT_FILE 
