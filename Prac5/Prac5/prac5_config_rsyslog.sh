#!/bin/bash

apt install rsyslog systemctl -y

# Funció per verificar si l'script està executat com a root
verifica_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "Aquest script ha de ser executat com a root."
        exit 1
    fi
}

# Funció per reiniciar el servei rsyslog
reinicia_rsyslog() {
    systemctl restart rsyslog
    echo "El servei rsyslog ha estat reiniciat."
}

# Configuro el server
configura_server() {
    # Modifico /etc/rsyslog.conf per permetre que rsyslog escolti al port 514
    sed -i 's/#\(.*ModLoad imudp\)/\1/' /etc/rsyslog.conf
    sed -i 's/#\(.*InputUDPServerRun 514\)/\1/' /etc/rsyslog.conf

    # Creo /etc/rsyslog.d/10-remot.conf
    cat <<EOF > /etc/rsyslog.d/10-remot.conf
$template GuardaRemots, "/var/log/remots/%HOSTNAME%/%timegenerated:1:10:date-rfc3339%"

:source, !isequal, "localhost" -?GuardaRemots
EOF

    reinicia_rsyslog
}

# Configuro els  altres contenidors
configura_contenidor() {
    # Crea /etc/rsyslog.d/90-remot.conf
    cat <<EOF > /etc/rsyslog.d/90-remot.conf
user.* @$IPSERVER:514
EOF

    reinicia_rsyslog
}

# Verifico que s'executi com a root
verifica_root

# Obtenim el hostname
hostname=$(hostname)

# Defineixo l'adreça IP del server
IPSERVER="198.18.88.254"

# Comprovo el hostname i configura en conseqüència
if [ "$hostname" == "server" ]; then
    configura_server
else
    configura_contenidor
fi

echo "Configuració de rsyslog completada."

