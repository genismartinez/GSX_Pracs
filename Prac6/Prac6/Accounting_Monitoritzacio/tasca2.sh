#!/bin/bash

# Monitorització amb vmstat abans de l'estrès
echo "Monitorització amb vmstat abans de l'estrès:" > monitorització.txt
vmstat 1 5 >> monitorització.txt

# Monitorització amb iostat abans de l'estrès
echo -e "\nMonitorització amb iostat abans de l'estrès:" >> monitorització.txt
iostat -x 1 3 >> monitorització.txt

# Estrès de la CPU, Memòria, Disc i Creació de Fils
echo -e "\nEstrès de la CPU, Memòria, Disc i Creació de Fils:" >> monitorització.txt

sysbench --test=cpu --num-threads=4 --cpu-max-prime=999999 run
stress-ng --cpu 512 --vm 256 --vm-bytes 90% --hdd 256 --fork 8192 --timeout 120s >> monitorització.txt 2>&1

# Monitorització amb vmstat durant l'estrès
echo -e "\nMonitorització amb vmstat durant l'estrès:" >> monitorització.txt
vmstat 1 5 >> monitorització.txt

# Monitorització amb iostat durant l'estrès
echo -e "\nMonitorització amb iostat durant l'estrès:" >> monitorització.txt
iostat -x 1 3 >> monitorització.txt

# Mostra els resultats
cat monitorització.txt

