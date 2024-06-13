#!/bin/bash

# Actualitzem els paquets i instal·lem cups i cups-pdf
sudo apt-get update
sudo apt-get install cups cups-pdf -y

# Configurem la impressora virtual cups-pdf
sudo lpadmin -p lpVirtual -E -v cups-pdf:/ -m everywhere

# Configurem el directori on es desaran els PDF generats
sudo mkdir -p /home/$USER/DocsPDF
sudo chown -R $USER:$USER /home/$USER/DocsPDF
sudo sed -i 's:Out ${HOME}/PDF:Out /home/'"$USER"'/DocsPDF:' /etc/cups/cups-pdf.conf

# Reiniciem el servei de cups per aplicar els canvis
sudo systemctl restart cups

# Configurem lpVirtual com impressora per defecte
sudo lpadmin -d lpVirtual

echo "Impressora configurada."

echo "Imprimint fitxer de prova..."
echo "Això és una prova d'impressió" > /home/$USER/DocsPDF/prova.txt
lp /home/$USER/DocsPDF/prova.txt
sleep 5

# Aturem el treball d'impressió
echo "Aturant impressió..."
lpstat -o | awk '{print $1}' | xargs cancel

echo "Script finalitzat."
