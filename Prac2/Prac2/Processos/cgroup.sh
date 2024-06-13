#!/bin/bash

# Obté el cgroup de la shell actual
cgroup=$(awk -F: '/cpu|cpuacct/ {print $3}' /proc/self/cgroup)

# Troba els processos en el cgroup
pids=$(grep -l $cgroup /proc/*/cgroup | cut -d/ -f3)

# Comprova si no s'han trobat PIDs
if [ -z "$pids" ]; then
    echo "No s'han generat processos en aquest cgroup."
else
    # Itera sobre els PIDs trobats
    for pid in $pids; do
        # Obté el PID i el PPID del procés
        pid_val=$(awk '/Pid/ {print $2}' /proc/$pid/status)
        ppid_val=$(awk '/PPid/ {print $2}' /proc/$pid/status)

        # Obté la comanda del procés
        command_val=$(tr -d '\0' < /proc/$pid/cmdline)

        # Imprimim la informació del procés
        echo "PID: $pid_val, PPID: $ppid_val, Comanda: $command_val"
    done
fi

