#!/bin/bash


#Cas dont la ville est vide (argument positionnel 1 vide)

if [ -z "$1" ]; then
	echo "Usage Invalide."
	echo "Dans cette version il faut spécifié une ville au 1er argument"
	echo "Usage : $0 'nomDeVille'"
	exit 1
fi

ville=$1

# Récupération de la date et de l'heure
date_jour=$(date +%F)      # date
heure=$(date +%H:%M)       # heure

# Température actuelle 
temp_actuelle=$(curl -s "wttr.in/${ville}?format=%t")


# Utilisation de curl pour récupérer la météo 
curl -s "wttr.in/${ville}?2&T" > meteo_brute.txt #2& récupérer météo daujourd'hui +demmain et T enlever la couleur

temp_demain_number=$(
    awk '
    BEGIN {
        header_count = 0
        in_second = 0
        sum = 0
        count = 0
    }

    # Chaque jour commence par cette grosse ligne avec les cases du tableau
    /┌──────────────────────────────┬───────────────────────┤/ {
        header_count++
        if (header_count == 2) {
            in_second = 1     # on est dans le tableau de demain
        } else if (header_count > 2 && in_second == 1) {
            in_second = 0     # sécurité si jamais il y avait un 3e tableau
        }
    }

    # On ne traite que les lignes du 2e tableau (demain)
    in_second {
        # On ne prend que les lignes avec des °C, sans km/h, mm, km
        if ($0 !~ /°C/ || $0 ~ /km\/h|mm| km/) next

        line = $0
        # Extraire toutes les températures de la ligne
        while (match(line, /[+-]?[0-9]+(\([0-9]+\))? ?°C/)) {
            temp_str = substr(line, RSTART, RLENGTH)
            gsub(/ ?°C/, "", temp_str)
            gsub(/\(.*\)/, "", temp_str)  # enlever (8) dans +9(8)

            if (temp_str ~ /^[+-]?[0-9]+$/) {
                sum += temp_str + 0
                count++
            }

            line = substr(line, RSTART + RLENGTH)
        }
    }

    END {
        if (count > 0) {
            avg = sum / count
            printf "%.0f\n", avg
        }
    }
    ' meteo_brute.txt
)


# Si on n'a rien trouvé, on met une valeur vide
if [ -z "$temp_demain_number" ]; then
    echo "Erreur : impossible d’extraire les températures de demain."
    exit 4
fi

# On reformate en chaîne avec le signe et °C
if [ "$temp_demain_number" -gt 0 ]; then
    temp_demain="+${temp_demain_number}°C"
else
    temp_demain="${temp_demain_number}°C"
fi

echo "${date_jour} - ${heure} - ${ville} : ${temp_actuelle} - ${temp_demain}" >> meteo.txt