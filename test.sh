#!/bin/bash

#Cas dont la ville est vide (argument positionnel 1 vide)
if [ -z "$1" ]; then
	echo "Usage Invalide."
	echo "Dans cette version il faut spécifié une ville au 1er argument"
	echo "Usage : $0 'nomDeVille'"
	exit 1
fi

ville=$1
date_jour=$(date +%F)
heure=$(date +%H:%M)

# Curl données métérologique pour la premiere vilile
temp_actuelle=$(curl -s "wttr.in/${ville}?format=%t")

# Curl données métérologique donnees pure
curl -s "wttr.in/${ville}?2&T" > meteo_brute.txt

# Logique pour filtrer les donnes dans les donnees pure
temp_demain=$(awk '
BEGIN {sum=0; count=0; day=0}
/┤/ && /Mon|Tue|Wed|Thu|Fri|Sat|Sun/ { day++ }
day==2 && /°C/ {
    # Take only the first number (actual temperature)
    if (match($0, /[+-]?[0-9]+/)) {
        val = substr($0, RSTART, RLENGTH)
        sum += val
        count++
    }
}
END {
    if (count>0) {
        avg = sum / count
        if (avg>0) printf("+%.0f°C\n", avg)
        else printf("%.0f°C\n", avg)
    } else {
        print "N/A"
    }
}' meteo_brute.txt)

# En cas de vide pour temperature demain
[ -z "$temp_demain" ] && temp_demain="N/A"

# Afficher date dans format specifique
echo "$date_jour - $heure - $ville : $temp_actuelle - $temp_demain" > meteo.txt

