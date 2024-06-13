#!/bin/sh

# Descripció:
#	eliminar les regles DROP del tràfic entre DMZ <-> INTRANET

# Assignatura: GSX
# Autor: Josep M Banús Alsina
# Versió: 1.0

for net in DMZ INTRANET
do
	# obtenir el nom dell pont
	id=$(docker network inspect --format='{{.Id}}' $net | cut -c1-12)
	[ -z $id ] && echo "No trobo el pont de $net" && continue
	bridge="br-$id"

	# obtenir el número de la regla que fa el DROP
	regla=$(iptables --line-numbers -nvL DOCKER-ISOLATION-STAGE-2 | grep $bridge | cut -f1 -d' ')
	[ -z $regla ] && echo "No hi ha la regla pel $bridge ..." && continue

	iptables -D DOCKER-ISOLATION-STAGE-2 $regla
done

