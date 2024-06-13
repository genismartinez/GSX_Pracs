#!/bin/bash

trap 'echo has rebut el senyal SIGUSR1 a les $(date) amb el valor $i' SIGUSR1 
trap '' INT TERM
for i in {1..12}
do
	echo "Executant el pas $i"
	sleep 5 
done
echo "El script ha finalitzat"
