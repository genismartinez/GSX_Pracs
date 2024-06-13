#!/bin/bash

# Obté el cgroup de la shell actual
cgroup=$(awk -F: '/cpu|cpuacct/ {print $3}' /proc/self/cgroup)

# Troba el PID del procés actual
current_pid=$(echo $$)

# Funció per obtenir el PID del procés pare
get_parent_pid() {
    local pid=$1
    # Obté el PPID del procés
    ppid=$(awk '/PPid/ {print $2}' /proc/$pid/status)
    echo "$ppid"
}

# Funció per obtenir la comanda associada amb un PID
get_command() {
    local pid=$1
    # Obté la comanda del procés
    command_val=$(tr -d '\0' < /proc/$pid/cmdline)
    echo "$command_val"
}

# Obté el PID del procés pare inicial
parent_pid=$(get_parent_pid $current_pid)

# Imprimeix la informació del procés actual
echo "PID: $current_pid, PPID: $parent_pid, Comanda: $(get_command $current_pid)"

# Itera fins arribar al primer procés generat en el mateix cgroup
while [ $parent_pid -ne 1 ]; do
    # Obté la comanda i el PPID del procés pare
    parent_command=$(get_command $parent_pid)
    echo "PID: $parent_pid, PPID: $(get_parent_pid $parent_pid), Comanda: $parent_command"
    # Obté el PID del següent procés pare
    parent_pid=$(get_parent_pid $parent_pid)
done

