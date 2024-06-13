#!/bin/bash

# Verificar permisos de sudo
if [[ $EUID -ne 0 ]]; then
   echo "Aquest script necessita ser executat amb privilegis de sudo."
   exit 1
fi

# Eliminar enllaços existents
echo "Eliminant enllaços existents..."

ip link del link1_veth1 2>/dev/null
ip link del link1_veth2 2>/dev/null
ip link del link2_veth1 2>/dev/null
ip link del link2_veth2 2>/dev/null
ip link del link3_veth1 2>/dev/null
ip link del link3_veth2 2>/dev/null
ip link del link4_veth1 2>/dev/null
ip link del link4_veth2 2>/dev/null

echo "Enllaços existents eliminats."
