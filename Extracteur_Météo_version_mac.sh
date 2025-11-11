#!/bin/bash

#ville par défaut
if [ -z "$1" ]; then
    echo " Aucun nom de ville spécifié, utilisation de la ville par défaut : Toulouse"
    ville="Toulouse"
else
    ville="$1"
fi

#date et heure
date_jour=$(date +%F)
heure=$(date +%H:%M)

#temp actuelle
temp_actuelle=$(curl -s "https://wttr.in/${ville}?format=%t")

#vérif que la ville existe
test_reponse=$(curl -s "https://wttr.in/${ville}?format=1")
if [[ "$test_reponse" == *"Unknown location"* ]]; then
    echo "Erreur : la ville '$ville' est inconnue sur wttr.in."
    exit 2
fi

#récupération des données format JSON
curl -s "https://wttr.in/${ville}?format=j1" -o meteo.json

#extraction de la temp moyenne de demain
temp_demain_number=$(awk -F'[:,]' '
    /avgtempC/ { print $2; exit }
' meteo.json | tr -d ' "')

#vérif du résultat
if [ -z "$temp_demain_number" ]; then
    echo "Erreur : impossible d’extraire les températures de demain."
    rm -f meteo.json
    exit 4
fi

#formatage de la temp
if [ "$temp_demain_number" -gt 0 ]; then
    temp_demain="+${temp_demain_number}°C"
else
    temp_demain="${temp_demain_number}°C"
fi

#écriture du résultat dans le fichier
echo "${date_jour} - ${heure} - ${ville} : ${temp_actuelle} - ${temp_demain}" >> meteo.txt
echo "Données météo enregistrées pour ${ville} dans meteo.txt"

#nettoyage
rm -f meteo.json

