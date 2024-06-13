#!/bin/bash 

 

function help { 

    echo "Us: fit_projectes" 

    echo "" 

    echo "Script configuracio projectes lab8" 

    echo "" 

    echo "Arguments:" 

    echo "  fit_projectes   Fitxer de projectes (un per linia amb camps separats per ':'" 

    echo "" 

    echo "Exemple" 

    echo "  $0 projects.txt" 

    echo "" 

} 

 

if [[ -z "$1" ]]; then 

 help 

 exit 1 

fi 

 

projecte="$1" 

# comprova si el directori del projecte existeix 

if [[ ! -d "/empresa/projectes/$projecte" ]]; then 

 echo "El directori del projecte no existeix." 

 exit 1 

fi 

 

grup_usuari=$(id -gn) 

grup_proj=$(ls -ld /empresa/projectes/$projecte | awk '{print $4}') 

echo "Grup del projecte: $grup_proj" 

if groups | grep -q "$grup_proj"; then 

 echo "L'usuari ja pertany al grup del projecte." 

else 

 usermod -a -G "$grup_proj" $(whoami) 

fi 

cd "/empresa/projectes/$projecte" 

umask 002 

echo "Iniciant el projecte $projecte..." 

start_time=$(date +%s) 

 

bash --rcfile <( 

 echo "trap 'echo Sortint...' EXIT" 

 echo "PS1='[$projecte] \u@\h:\w\$ '" 

) 

elapsed_time=$(( $(date +%s) - $start_time )) 

 

echo "S'ha estat dins del projecte $projecte durant $elapsed_time segons."


